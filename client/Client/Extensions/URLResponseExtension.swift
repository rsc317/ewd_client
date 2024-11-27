//
//  URLResponse.swift
//  client
//
//  Created by Emircan Duman on 21.11.24.
//
import Foundation

extension URLResponse {
    func prettyPrinted(data: Data?) -> String {
        var output = "\n--- HTTP Response Debugging ---\n"
        
        if let httpResponse = self as? HTTPURLResponse {
            output += "Status Code: \(httpResponse.statusCode)\n"
            
            output += "Headers:\n"
            for (key, value) in httpResponse.allHeaderFields {
                output += "  \(key): \(value)\n"
            }
        } else {
            output += "Keine HTTP-Response gefunden.\n"
        }
        
        if let responseData = data {
            if let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: []),
               let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
               let prettyJsonString = String(data: prettyJsonData, encoding: .utf8) {
                output += "Body (JSON Pretty-Printed):\n\(prettyJsonString)\n"
            } else if let bodyString = String(data: responseData, encoding: .utf8) {
                output += "Body:\n\(bodyString)\n"
            } else {
                output += "Body: (non-UTF8 data, \(responseData.count) bytes)\n"
            }
        } else {
            output += "Body: None\n"
        }
        
        output += "--- End of HTTP Response ---\n"
        return output
    }
    
    func prettyPrinted(data: Data) -> String {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
              let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
              let prettyString = String(data: prettyData, encoding: .utf8) else {
            return "Keine JSON-Daten zum Anzeigen."
        }
        return prettyString
    }
}
