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
        //case id
        case title
        case description
        case isDeleted = "is_deleted"
        case duration
        case images
        case coordinate
        case comments
        case likes
    }
    
    let id = UUID()
    //var id: Int = 0
    var title: String
    var description: String
    var isDeleted: Bool = false
    var duration: Duration
    var images: [ImageResponse] = []
    var coordinate: GeoCoordinate
    var comments: [Comment] = []
    var likes: [Like] = []
    

    init(title: String, description: String, duration: Duration, coordinate: GeoCoordinate) {
        self.title = title
        self.description = description
        self.duration = duration
        self.coordinate = coordinate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.isDeleted = try container.decode(Bool.self, forKey: .isDeleted)
        self.duration = try container.decode(Duration.self, forKey: .duration)
        self.coordinate = try container.decode(GeoCoordinate.self, forKey: .coordinate)
        self.images = try container.decode([ImageResponse].self, forKey: .images)
        self.comments = try container.decode([Comment].self, forKey: .comments)
        self.likes = try container.decode([Like].self, forKey: .likes)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        //try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(isDeleted, forKey: .isDeleted)
        try container.encode(duration, forKey: .duration)
        try container.encode(coordinate, forKey: .coordinate)
        try container.encode(images, forKey: .images)
        try container.encode(comments, forKey: .comments)
        try container.encode(likes, forKey: .likes)
    }
}
