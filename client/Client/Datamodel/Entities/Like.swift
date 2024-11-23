//
//  Like.swift
//  client
//
//  Created by Emircan Duman on 06.11.24.
//

import Foundation
import SwiftData


struct Like: Codable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case isLike="is_like"
    }
    
    let id = UUID()
    var isLike: Bool
    
    init(isLike: Bool ) {
        self.isLike = isLike
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isLike = try container.decode(Bool.self, forKey: .isLike)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isLike, forKey: .isLike)
    }
}
