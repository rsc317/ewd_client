//
//  LikeModel.swift
//  client
//
//  Created by Emircan Duman on 06.11.24.
//

import Foundation
import SwiftData


@Model
class LikeModel: Codable, Identifiable {
    
    enum CodingKeys: String, CodingKey {
        case isLike
        case user
        case pinPoint
    }
    
    var isLike: Bool
    var user: UserModel
    var pinPoint: PinPointModel
    
    init(isLike: Bool, user: UserModel, pinPoint: PinPointModel) {
        self.isLike = isLike
        self.user = user
        self.pinPoint = pinPoint
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.user = try container.decode(UserModel.self , forKey: .user)
        self.isLike = try container.decode(Bool.self, forKey: .isLike)
        self.pinPoint = try container.decode(PinPointModel.self, forKey: .pinPoint)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isLike, forKey: .isLike)
        try container.encode(pinPoint, forKey: .pinPoint)
        try container.encode(user, forKey: .user)
    }
}
