//
//  AuthentificationtokenModel.swift
//  client
//
//  Created by Emircan Duman on 06.11.24.
//

import Foundation
import SwiftData


@Model
class AuthenticationToken: Codable, Identifiable {
    
    enum CodingKeys: String, CodingKey {
        case token
        case duration
    }
    
    var token: String
    @Relationship(deleteRule: .cascade) var duration: Duration
    
    init(token: String, duration: Duration) {
        self.token = token
        self.duration = duration
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        token = try container.decode(String.self, forKey: .token)
        duration = try container.decode(Duration.self, forKey: .duration)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(token, forKey: .token)
        try container.encode(duration, forKey: .duration)
    }
}
