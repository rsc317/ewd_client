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
        case pinPoint
    }
    let id = UUID()
    var message: String
    var pinPoint: PinPoint
    
    init(message: String, pinPoint: PinPoint) {
        self.message = message
        self.pinPoint = pinPoint
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try container.decode(String.self, forKey: .message)
        pinPoint = try container.decode(PinPoint.self, forKey: .pinPoint)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(message, forKey: .message)
        try container.encode(pinPoint, forKey: .pinPoint)
    }
}
