////
////  User.swift
////  client
////
////  Created by Emircan Duman on 06.11.24.
////
//
//import Foundation
//import SwiftData
//
//
//struct User: Codable, Identifiable {
//    enum CodingKeys: String, CodingKey {
//        case email
//        case tokens
//        case username
//        case isLoggedIn
//    }
//    @Attribute(.unique) var email: String
//    @Relationship(deleteRule: .cascade) var tokens: [AuthenticationToken] = []
//    
//    var username: String
//    var isLoggedIn: Bool
//    
//    init(email: String, username: String, isLoggedIn: Bool = false) {
//        self.email = email
//        self.username = username
//        self.isLoggedIn = isLoggedIn
//    }
//    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.email = try container.decode(String.self, forKey: .email)
//        self.tokens = try container.decode([AuthenticationToken].self, forKey: .tokens)
//        self.username = try container.decode(String.self, forKey: .username)
//        self.isLoggedIn = try container.decode(Bool.self, forKey: .isLoggedIn)
//    }
//    
//    func encode(to encoder: any Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(email, forKey: .email)
//        try container.encode(tokens, forKey: .tokens)
//        try container.encode(username, forKey: .username)
//        try container.encode(isLoggedIn, forKey: .isLoggedIn)
//    }
//    
//    static func mock() -> User {
//        return User(email: UUID().uuidString, username: "admin", isLoggedIn: true)
//    }
//}
