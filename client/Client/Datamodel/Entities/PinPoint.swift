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
        case serverId="id"
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
    var serverId: Int?
    var title: String
    var description: String
    var isDeleted: Bool = false
    var duration: Duration
    var coordinate: GeoCoordinate

    init(title: String, description: String, duration: Duration, coordinate: GeoCoordinate) {
        self.title = title
        self.description = description
        self.duration = duration
        self.coordinate = coordinate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.serverId = try container.decode(Int.self, forKey: .serverId)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.isDeleted = try container.decode(Bool.self, forKey: .isDeleted)
        self.duration = try container.decode(Duration.self, forKey: .duration)
        self.coordinate = try container.decode(GeoCoordinate.self, forKey: .coordinate)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(serverId, forKey: .serverId)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(isDeleted, forKey: .isDeleted)
        try container.encode(duration, forKey: .duration)
        try container.encode(coordinate, forKey: .coordinate)
    }
    
    func getPrettyPrint() -> String {
        return "\(String(format: "%.6f",coordinate.coordinates.latitude)) / \(String(format: "%.6f", coordinate.coordinates.longitude))"
    }
}
