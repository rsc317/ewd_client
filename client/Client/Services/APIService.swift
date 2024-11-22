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
            return "Kein Token gefunden"
        case .unknown:
            return "Ein unbekannter Fehler ist aufgetreten."
        }
    }
}

class APIService {
    static let shared = APIService()
    private init() {}
    
    /**
     IP vom lokalen Gerät wo das Backend läuft
     */
    private let baseURL = "http://192.168.0.56:8080/"
    

    func get<T: Codable>(endpoint: String, queryParameters: [String: String]? = nil) async throws -> T {
        guard var urlComponents = URLComponents(string: "\(baseURL)\(endpoint)") else {
            throw APIError.invalidURL
        }
        
        if let queryParameters = queryParameters {
            urlComponents.queryItems = queryParameters.map { key, value in
                URLQueryItem(name: key, value: value)
            }
        }
        
        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }
        
        guard let token = AuthenticationManager.shared.token?.token else {
            throw APIError.missingToken
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                throw APIError.invalidResponse
            }
            print("HTTP_STATUS_CODE: \(httpResponse.statusCode)")
            print(response.prettyPrinted(data: data))
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                return decodedData
            } catch let decodingError {
                throw APIError.decodingFailed(decodingError)
            }
        } catch let requestError {
            throw APIError.requestFailed(requestError)
        }
    }
    
    func post<T: Codable>(endpoint: String, body: T) async throws {
         guard let url = URL(string: "\(baseURL)\(endpoint)") else {
             throw APIError.invalidURL
         }
         
         guard let token = AuthenticationManager.shared.token?.token else {
             throw APIError.missingToken
         }
         
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         request.setValue("application/json", forHTTPHeaderField: "Content-Type")
         request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
         do {
             let jsonData = try JSONEncoder().encode(body)
             if let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []),
                let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
                let prettyJsonString = String(data: prettyJsonData, encoding: .utf8) {
                 print("JSON Body (Pretty-Printed):\n\(prettyJsonString)")
             }
             request.httpBody = jsonData
         } catch {
             throw APIError.decodingFailed(error)
         }
         
         do {
             let (data, response) = try await URLSession.shared.data(for: request)
             print(response.prettyPrinted(data: data))
             guard let httpResponse = response as? HTTPURLResponse,
                   200..<300 ~= httpResponse.statusCode else {
                 throw APIError.invalidResponse
             }
         } catch let requestError {
             throw APIError.requestFailed(requestError)
         }
     }
    
    func postLogin<T: Codable, U: Codable>(endpoint: String, body: T) async throws -> U {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
       
        do {
            let jsonData = try JSONEncoder().encode(body)
            request.httpBody = jsonData
        } catch {
            throw APIError.decodingFailed(error)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                throw APIError.invalidResponse
            }
            
            do {
                let decodedData = try JSONDecoder().decode(U.self, from: data)
                return decodedData
            } catch let decodingError {
                throw APIError.decodingFailed(decodingError)
            }
        } catch let requestError {
            throw APIError.requestFailed(requestError)
        }
    }
}
