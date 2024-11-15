//
//  PinPoints.swift
//  client
//
//  Created by Emircan Duman on 06.11.24.
//

import Foundation
import SwiftData

@Model
class PinPoint: Codable, Identifiable {
    
    enum CodingKeys: String, CodingKey {
        case title
        case body
        case isDeleted
        case user
        case duration
        case geoCoordinate
    }
    
    var title: String
    var body: String
    var isDeleted: Bool
    var user: User
    @Relationship(deleteRule: .cascade) var duration: Duration
    @Relationship(deleteRule: .cascade) var geoCoordinate: GeoCoordinate
    @Relationship(deleteRule: .cascade, inverse: \LocationImage.pinPoint) var images: [LocationImage] = []
    @Relationship(deleteRule: .cascade, inverse: \Comment.pinPoint) var comments: [Comment] = []
    @Relationship(deleteRule: .cascade, inverse: \Like.pinPoint) var likes: [Like] = []

    init(title: String, body: String, isDeleted: Bool, user: User, duration: Duration, geoCoordinate: GeoCoordinate) {
        self.title = title
        self.body = body
        self.isDeleted = isDeleted
        self.user = user
        self.duration = duration
        self.geoCoordinate = geoCoordinate
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.body = try container.decode(String.self, forKey: .body)
        self.isDeleted = try container.decode(Bool.self, forKey: .isDeleted)
        self.user = try container.decode(User.self, forKey: .user)
        self.duration = try container.decode(Duration.self, forKey: .duration)
        self.geoCoordinate = try container.decode(GeoCoordinate.self, forKey: .geoCoordinate)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(body, forKey: .body)
        try container.encode(isDeleted, forKey: .isDeleted)
        try container.encode(user, forKey: .user)
        try container.encode(duration, forKey: .duration)
        try container.encode(geoCoordinate, forKey: .geoCoordinate)
    }
}
