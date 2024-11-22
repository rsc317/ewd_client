//
//  Authentificationtoken.swift
//  client
//
//  Created by Emircan Duman on 06.11.24.
//

import Foundation
import SwiftData


struct AuthenticationToken: Codable, Identifiable {
    
    enum CodingKeys: String, CodingKey {
        case token
        case expiresIn="expires_in"
    }
    
    var id: UUID = UUID()
    var token: String
    var expireDate: Date
    
    init(token: String, expiresIn: Double) {
        self.token = token
        self.expireDate = Date(timeIntervalSinceNow: expiresIn)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        token = try container.decode(String.self, forKey: .token)
        
        let expiresIn = try container.decode(Double.self, forKey: .expiresIn)
        expireDate = Date().addingTimeInterval(expiresIn)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(token, forKey: .token)
        
        let expireInterval = expireDate.timeIntervalSinceReferenceDate
        try container.encode(expireInterval, forKey: .expiresIn)
    }
}
