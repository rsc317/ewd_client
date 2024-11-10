//
//  UserModel.swift
//  client
//
//  Created by Emircan Duman on 06.11.24.
//

import Foundation
import SwiftData

@Model
class UserModel: Codable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case email
        case tokens
        case username
        case isLoggedIn
    }
    @Attribute(.unique) var email: String
    @Relationship(deleteRule: .cascade) var tokens: [AuthenticationTokenModel] = []
    @Relationship(deleteRule: .cascade, inverse: \PinPointModel.user) var geoCoordinate: [PinPointModel] = []
    @Relationship(deleteRule: .cascade, inverse: \CommentModel.user) var comments: [CommentModel] = []
    @Relationship(deleteRule: .cascade, inverse: \LikeModel.user) var likes: [LikeModel] = []
    
    var username: String
    var isLoggedIn: Bool
    
    init(email: String, tokens: [AuthenticationTokenModel], username: String, isLoggedIn: Bool = false) {
        self.email = email
        self.tokens = tokens
        self.username = username
        self.isLoggedIn = isLoggedIn
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.email = try container.decode(String.self, forKey: .email)
        self.tokens = try container.decode([AuthenticationTokenModel].self, forKey: .tokens)
        self.username = try container.decode(String.self, forKey: .username)
        self.isLoggedIn = try container.decode(Bool.self, forKey: .isLoggedIn)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(email, forKey: .email)
        try container.encode(tokens, forKey: .tokens)
        try container.encode(username, forKey: .username)
        try container.encode(isLoggedIn, forKey: .isLoggedIn)
    }
}
