//
//  PasswordRequest.swift
//  client
//
//  Created by Emircan Duman on 12.01.25.
//

import Foundation

struct PasswordForgotRequest: Codable {
    enum CodingKeys: String, CodingKey {
        case email
    }
    
    let email: String
    
    init(email: String) {
        self.email = email
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        email = try container.decode(String.self, forKey: .email)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(email, forKey: .email)
    }
}

struct PasswordForgotConfirmRequest: Codable {
    enum CodingKeys: String, CodingKey {
        case token
        case password
    }
    
    let token: String
    let password: String
    
    init(token: String, password: String) {
        self.token = token
        self.password = password
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        token = try container.decode(String.self, forKey: .token)
        password = try container.decode(String.self, forKey: .password)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(token, forKey: .token)
        try container.encode(password, forKey: .password)
    }
}
