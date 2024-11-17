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
        case .unknown:
            return "Ein unbekannter Fehler ist aufgetreten."
        }
    }
}

class APIService {
    static let shared = APIService()
    private init() {}
    
    private let baseURL = "http://localhost:8080/api"
    

    func get<T: Codable>(endpoint: String) async throws -> T {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                throw APIError.invalidResponse
            }
            
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
    
    func post<T: Codable, U: Codable>(endpoint: String, body: T) async throws -> U {
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
