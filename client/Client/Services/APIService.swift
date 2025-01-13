//
//  APIService.swift
//  client
//
//  Created by Emircan Duman on 15.11.24.
//
import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
    case unknown
    case missingToken
    case authFailed(Error)
    case unauthorized
    case noContentType
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Ungültige URL."
        case .requestFailed(let error):
            return "Anfrage fehlgeschlagen: \(error.localizedDescription)"
        case .invalidResponse:
            return "Ungültige Antwort vom Server."
        case .decodingFailed(let error):
            return "Fehler beim Dekodieren der Daten: \(error.localizedDescription)"
        case .authFailed(let error):
            return "Fehler beim Authentifizieren: \(error.localizedDescription)"
        case .missingToken:
            return "Kein Authentifizierungs Token vorhanden."
        case .unknown:
            return "Ein unbekannter Fehler ist aufgetreten."
        case .unauthorized:
            return "Zugriff auf die Ressource ist verweigert."
        case .noContentType:
            return "Kein Content-Type vorhanden."
        }
    }
}

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE, PATCH
}

class APIService {
    static let shared = APIService()
    private init() {}
    private var maxReloginAttempts: Int = 1
    
    /// Basis-URL des Backends
    #if NO_HTTPS
    private let baseURL = "http://localhost:8443/"
    #else
    private let baseURL = "https://localhost:8443/"
    #endif
    
    /// Generische Anfrage-Methode
    /// - Parameters:
    ///   - method: HTTP-Methode (GET, POST, etc.)
    ///   - endpoint: API-Endpunkt
    ///   - queryParameters: Optionales Dictionary für Query-Parameter
    ///   - body: Optionaler Body, der codierbar ist
    ///   - requiresAuth: Bool, ob ein Authentifizierungstoken benötigt wird
    /// - Returns: Dekodierte Antwort des Typs `U`
    private func request<T: Codable, U: Codable>(
        method: HTTPMethod,
        endpoint: String,
        queryParameters: [String: String]? = nil,
        headers: [String: String]? = nil,
        body: T? = nil,
        requiresAuth: Bool = true
    ) async throws -> U {
        
        guard var urlComponents = URLComponents(string: "\(baseURL)\(endpoint)") else {
            throw APIError.invalidURL
        }
        
        if let queryParameters = queryParameters {
            urlComponents.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if requiresAuth {
            guard let token = AuthenticationManager.shared.token?.token else {
                throw APIError.missingToken
            }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let headers = headers {
            headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        }
        
        if let body = body {
            if let body = body as? String {
                request.httpBody = body.data(using: .utf8)
            } else {
                do {
                    let jsonData = try JSONEncoder().encode(body)
                    request.httpBody = jsonData
                } catch {
                    throw APIError.decodingFailed(error)
                }
            }
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            print("HTTP_STATUS_CODE: \(httpResponse.statusCode)")
            if let contentType = httpResponse.value(forHTTPHeaderField: "Content-Type") {
                print("Content-Type: \(contentType)")
            } else {
                print("Content-Type: Nicht verfügbar")
            }
            
            guard 200..<300 ~= httpResponse.statusCode else {
                throw APIError.invalidResponse
            }
            
            if 403 == httpResponse.statusCode {
                if maxReloginAttempts > 0 {
                    AuthenticationManager.shared.attemptReLoginOrLogout()
                    maxReloginAttempts -= 1
                }
                
                throw APIError.unauthorized
            }
            
            guard let contentType = httpResponse.value(forHTTPHeaderField: "Content-Type") else {
                throw APIError.unknown
            }
            
            if contentType.contains("application/json") {
                do {
                    let decodedData = try JSONDecoder().decode(U.self, from: data)
                    return decodedData
                } catch let decodingError {
                    print("JSON-Dekodierungsfehler: \(decodingError.localizedDescription)")
                    throw APIError.decodingFailed(decodingError)
                }
            } else if contentType.contains("text/plain") && U.self == String.self {
                if let decodedString = String(data: data, encoding: .utf8) as? U {
                    return decodedString
                } else {
                    throw APIError.decodingFailed(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Konnte den Text nicht dekodieren."]))
                }
            } else {
                print("Unerwarteter Content-Type: \(contentType)")
                throw APIError.invalidResponse
            }
            
        } catch let requestError {
            print("RECEIVED ERROR FROM NETWORK: \(requestError)")
            throw APIError.requestFailed(requestError)
        }
    }
    
    func get<T: Codable>(endpoint: String, queryParameters: [String: String]? = nil) async throws -> T {
        return try await request(
            method: .GET,
            endpoint: endpoint,
            queryParameters: queryParameters,
            headers: ["Content-Type":"application/json"],
            body: Optional<Data>.none,
            requiresAuth: true
        )
    }
    
    func post<T: Codable, U: Codable>(endpoint: String, body: T) async throws -> U {
        return try await request(
            method: .POST,
            endpoint: endpoint,
            queryParameters: nil,
            headers: ["Content-Type":"application/json"],
            body: body,
            requiresAuth: true
        )
    }
    
    func getLogin<T: Codable>(endpoint: String = "auth/login", headers: [String: String]? = nil) async throws -> T {
        return try await request(
            method: .GET,
            endpoint: endpoint,
            headers: headers,
            body: Optional<Data>.none,
            requiresAuth: false
        )
    }
    
    func postSignUp<T: Codable, U: Codable>(endpoint: String = "auth/signup", body: T) async throws -> U {
        return try await request(
            method: .POST,
            endpoint: endpoint,
            queryParameters: nil,
            headers: ["Content-Type":"application/json"],
            body: body,
            requiresAuth: false
        )
    }
    
    func getVerification<T: Codable>(endpoint: String = "user/verification") async throws -> T {
        return try await request(
            method: .GET,
            endpoint: endpoint,
            body: Optional<Data>.none,
            requiresAuth: true
        )
    }
    
    func postVerification<T: Codable>(endpoint: String = "user/verification", body: String) async throws -> T {
        print("posting verification to '\(endpoint)': \(body)")
        return try await request(
            method: .POST,
            endpoint: endpoint,
            headers: ["Content-Type":"text/plain"],
            body: body,
            requiresAuth: true
        )
    }
}
