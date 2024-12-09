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
        case message
        case username
        case timeStamp
    }
    
    let id = UUID()
    var message: String
    var username: String
    var timeStamp: Date = Date()
    
    init (message: String, username: String) {
        self.message = message
        self.username = username
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try container.decode(String.self, forKey: .message)
        username = try container.decode(String.self, forKey: .username)
        timeStamp = try container.decode(Date.self, forKey: .timeStamp)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(message, forKey: .message)
        try container.encode(username, forKey: .username)
        try container.encode(timeStamp, forKey: .timeStamp)
    }
}
