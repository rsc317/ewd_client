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
            return "Kein Token gefunden."
        case .unknown:
            return "Ein unbekannter Fehler ist aufgetreten."
        }
    }
}

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE, PATCH
}

class APIService {
    static let shared = APIService()
    private init() {}
    
    /// Basis-URL des Backends
    private let baseURL = "http://192.168.0.56:8080/"
    
    /// Generische Anfrage-Methode
    /// - Parameters:
    ///   - method: HTTP-Methode (GET, POST, etc.)
    ///   - endpoint: API-Endpunkt
    ///   - queryParameters: Optionales Dictionary für Query-Parameter
    ///   - body: Optionaler Body, der codierbar ist
    ///   - requiresAuth: Bool, ob ein Authentifizierungstoken benötigt wird
    /// - Returns: Dekodierte Antwort des Typs `U`
    func request<T: Codable, U: Codable>(
        method: HTTPMethod,
        endpoint: String,
        queryParameters: [String: String]? = nil,
        body: T? = nil,
        requiresAuth: Bool = true
    ) async throws -> U {
        
        // URL-Komponenten erstellen
        guard var urlComponents = URLComponents(string: "\(baseURL)\(endpoint)") else {
            throw APIError.invalidURL
        }
        
        // Query-Parameter hinzufügen, falls vorhanden
        if let queryParameters = queryParameters {
            urlComponents.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        // Endgültige URL abrufen
        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }
        
        // URLRequest konfigurieren
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Authentifizierungstoken hinzufügen, falls erforderlich
        if requiresAuth {
            guard let token = AuthenticationManager.shared.token?.token else {
                throw APIError.missingToken
            }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Body hinzufügen, falls vorhanden
        if let body = body {
            do {
                let jsonData = try JSONEncoder().encode(body)
                request.httpBody = jsonData
                
                // Optional: Pretty-Print des JSON-Bodys für Debugging
                if let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []),
                   let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
                   let prettyJsonString = String(data: prettyJsonData, encoding: .utf8) {
                    print("JSON Body (Pretty-Printed):\n\(prettyJsonString)")
                }
            } catch {
                throw APIError.decodingFailed(error)
            }
        }
        
        do {
            // Anfrage senden
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Antwort validieren
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            // Debug: HTTP Status Code und Content-Type
            print("HTTP_STATUS_CODE: \(httpResponse.statusCode)")
            if let contentType = httpResponse.value(forHTTPHeaderField: "Content-Type") {
                print("Content-Type: \(contentType)")
            } else {
                print("Content-Type: Nicht verfügbar")
            }
            
            // Debug: Antwortinhalt als String
            if let responseString = String(data: data, encoding: .utf8) {
                print("Antwortdaten (als String):\n\(responseString)")
            } else {
                print("Antwortdaten konnten nicht als String dekodiert werden.")
            }
            
            guard 200..<300 ~= httpResponse.statusCode else {
                // Optional: Weitere Fehlerbehandlung basierend auf Statuscode
                throw APIError.invalidResponse
            }
            
            // Content-Type der Antwort ermitteln
            guard let contentType = httpResponse.value(forHTTPHeaderField: "Content-Type") else {
                throw APIError.unknown
            }
            
            // Dekodierung basierend auf Content-Type
            if contentType.contains("application/json") {
                // JSON-Daten dekodieren
                do {
                    let decodedData = try JSONDecoder().decode(U.self, from: data)
                    return decodedData
                } catch let decodingError {
                    print("JSON-Dekodierungsfehler: \(decodingError.localizedDescription)")
                    throw APIError.decodingFailed(decodingError)
                }
            } else if contentType.contains("text/plain") && U.self == String.self {
                // Plain-Text-Daten dekodieren
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
            throw APIError.requestFailed(requestError)
        }
    }
    
    // Beispiel für spezifische Methoden, die die generische `request`-Methode nutzen
    
    func get<T: Codable>(endpoint: String, queryParameters: [String: String]? = nil) async throws -> T {
        return try await request(
            method: .GET,
            endpoint: endpoint,
            queryParameters: queryParameters,
            body: Optional<Data>.none, // Kein Body für GET-Anfragen
            requiresAuth: true
        )
    }
    
    func post<T: Codable, U: Codable>(endpoint: String, body: T) async throws -> U {
        return try await request(
            method: .POST,
            endpoint: endpoint,
            queryParameters: nil,
            body: body,
            requiresAuth: true
        )
    }
    
    func postLogin<T: Codable, U: Codable>(endpoint: String, body: T) async throws -> U {
        return try await request(
            method: .POST,
            endpoint: endpoint,
            queryParameters: nil,
            body: body,
            requiresAuth: false // Annahme: Login benötigt kein Auth-Token
        )
    }
}

// Erweiterung zur Pretty-Print der Antwort (optional)
extension URLResponse {
    func prettyPrinted(data: Data) -> String {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
              let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
              let prettyString = String(data: prettyData, encoding: .utf8) else {
            return "Keine JSON-Daten zum Anzeigen."
        }
        return prettyString
    }
}
