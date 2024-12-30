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
        case expiresIn = "expires_in"
        case userVerified
    }
    
    var id: UUID = UUID()
    var token: String
    var expireDate: Date
    var userVerified: Bool
    
    init(token: String, expiresIn: Double, userVerified: Bool) {
        self.token = token
        self.userVerified = userVerified
        self.expireDate = Date(timeIntervalSinceNow: expiresIn / 1000)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        token = try container.decode(String.self, forKey: .token)
        userVerified = try container.decode(Bool.self, forKey: .userVerified)
        let expiresInMilliseconds = try container.decode(Double.self, forKey: .expiresIn)
        expireDate = Date(timeIntervalSinceNow: expiresInMilliseconds / 1000)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(token, forKey: .token)
        try container.encode(userVerified, forKey: .userVerified)
        let remainingMilliseconds = expireDate.timeIntervalSinceNow * 1000
        try container.encode(remainingMilliseconds, forKey: .expiresIn)
    }
}
