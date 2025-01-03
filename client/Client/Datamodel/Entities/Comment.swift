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
    var username: String?
    var createdAt: Date = Date()
    
    init (content: String) {
        self.content = content
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        content = try container.decode(String.self, forKey: .content)
        username = try container.decode(String.self, forKey: .username)
        let dateString = try container.decode(String.self, forKey: .createdAt)
        let formatter = Comment.dateFormatter
        guard let date = formatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: .createdAt,
                                                   in: container,
                                                   debugDescription: "Invalid date format: \(dateString)")
        }
        createdAt = date
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(content, forKey: .content)
        try container.encode(username, forKey: .username)
        try container.encode(Comment.dateFormatter.string(from: createdAt), forKey: .createdAt)
    }
    
    public static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }
}
