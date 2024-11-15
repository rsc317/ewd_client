//
//  LocationImage.swift
//  client
//
//  Created by Emircan Duman on 06.11.24.
//

import Foundation
import SwiftData


struct ImageResponse: Codable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case label
        case data
    }
    
    let id = UUID()
    let imageData: String
    var label: String
    
    init(label: String, data: String) {
        self.imageData = data
        self.label = label
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.label = try container.decode(String.self, forKey: .label)
        self.imageData = try container.decode(String.self, forKey: .data)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(imageData, forKey: .data)
        try container.encode(label, forKey: .label)
    }
}
