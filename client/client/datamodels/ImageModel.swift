//
//  ImageModel.swift
//  client
//
//  Created by Emircan Duman on 06.11.24.
//

import Foundation
import SwiftData


@Model
class ImageModel: Codable, Identifiable {
    
    enum CodingKeys: String, CodingKey {
        case filePath
        case label
        case type
        case pinPoint
    }
    
    var filePath: String
    var label: String
    var type: ImageType
    var pinPoint: PinPointModel
    
    init(filePath: String, label: String, type: ImageType, pinPoint: PinPointModel) {
        self.filePath = filePath
        self.label = label
        self.type = type
        self.pinPoint = pinPoint
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.filePath = try container.decode(String.self, forKey: .filePath)
        self.label = try container.decode(String.self, forKey: .label)
        self.type = try container.decode(ImageType.self, forKey: .type)
        self.pinPoint = try container.decode(PinPointModel.self, forKey: .pinPoint)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(filePath, forKey: .filePath)
        try container.encode(label, forKey: .label)
        try container.encode(type, forKey: .type)
        try container.encode(pinPoint, forKey: .pinPoint)
    }
}


enum ImageType: String, Codable {
    case png = "png"
    case jpeg = "jpeg"
    case gif = "gif"
    case webp = "webp"
    case svg = "svg"
}
