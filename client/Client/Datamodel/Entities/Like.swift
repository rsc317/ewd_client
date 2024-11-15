//
//  Like.swift
//  client
//
//  Created by Emircan Duman on 06.11.24.
//

import Foundation
import SwiftData


@Model
class Like: Codable, Identifiable {
    
    enum CodingKeys: String, CodingKey {
        case isLike
        case user
        case pinPoint
    }
    
    var isLike: Bool
    var user: User
    var pinPoint: PinPoint
    
    init(isLike: Bool, user: User, pinPoint: PinPoint) {
        self.isLike = isLike
        self.user = user
        self.pinPoint = pinPoint
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.user = try container.decode(User.self , forKey: .user)
        self.isLike = try container.decode(Bool.self, forKey: .isLike)
        self.pinPoint = try container.decode(PinPoint.self, forKey: .pinPoint)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isLike, forKey: .isLike)
        try container.encode(pinPoint, forKey: .pinPoint)
        try container.encode(user, forKey: .user)
    }
}
