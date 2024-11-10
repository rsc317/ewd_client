//
//  CommentModel.swift
//  client
//
//  Created by Emircan Duman on 06.11.24.
//

import Foundation
import SwiftData


@Model
class CommentModel: Codable, Identifiable {
    
    enum CodingKeys: String, CodingKey {
        case message
        case user
        case pinPoint
    }
    
    var message: String
    var user: UserModel
    var pinPoint: PinPointModel
    
    init(message: String, user: UserModel, pinPoint: PinPointModel) {
        self.message = message
        self.user = user
        self.pinPoint = pinPoint
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try container.decode(String.self, forKey: .message)
        user = try container.decode(UserModel.self, forKey: .user)
        pinPoint = try container.decode(PinPointModel.self, forKey: .pinPoint)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(message, forKey: .message)
        try container.encode(user, forKey: .user)
        try container.encode(pinPoint, forKey: .pinPoint)
    }
}
