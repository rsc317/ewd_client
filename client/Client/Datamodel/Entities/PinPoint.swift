//
//  PinPoints.swift
//  client
//
//  Created by Emircan Duman on 06.11.24.
//

import Foundation
import SwiftData


struct PinPoint: Codable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case isDeleted
        case user
        case duration
        case geoCoordinate
        case images
        case comments
        case likes
    }
    
    let id = UUID()
    let title: String
    let description: String
    var isDeleted: Bool
    let user: User
    let duration: Duration
    let geoCoordinate: GeoCoordinate
    var images: [ImageResponse] = []
    var comments: [Comment] = []
    var likes: [Like] = []

    init(title: String, description: String, isDeleted: Bool, user: User, duration: Duration, geoCoordinate: GeoCoordinate) {
        self.title = title
        self.description = description
        self.isDeleted = isDeleted
        self.user = user
        self.duration = duration
        self.geoCoordinate = geoCoordinate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.isDeleted = try container.decode(Bool.self, forKey: .isDeleted)
        self.user = try container.decode(User.self, forKey: .user)
        self.duration = try container.decode(Duration.self, forKey: .duration)
        self.geoCoordinate = try container.decode(GeoCoordinate.self, forKey: .geoCoordinate)
        self.images = try container.decode([ImageResponse].self, forKey: .images)
        self.comments = try container.decode([Comment].self, forKey: .comments)
        self.likes = try container.decode([Like].self, forKey: .likes)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(isDeleted, forKey: .isDeleted)
        try container.encode(user, forKey: .user)
        try container.encode(duration, forKey: .duration)
        try container.encode(geoCoordinate, forKey: .geoCoordinate)
    }
}
