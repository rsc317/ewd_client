//
//  Comment.swift
//  client
//
//  Created by Emircan Duman on 06.11.24.
//

import Foundation
import SwiftData


struct Comment: Codable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case content
        case username
        case createdAt="created_at"
    }
    
    let id = UUID()
    var content: String
    var username: String
    var createdAt: Date = Date()
    
    init (content: String, username: String) {
        self.content = content
        self.username = username
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        content = try container.decode(String.self, forKey: .content)
        username = try container.decode(String.self, forKey: .username)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(content, forKey: .content)
        try container.encode(username, forKey: .username)
        try container.encode(createdAt, forKey: .createdAt)
    }
}
