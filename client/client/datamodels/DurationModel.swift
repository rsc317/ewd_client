//
//  DurationModel.swift
//  client
//
//  Created by Emircan Duman on 06.11.24.
//

import Foundation
import SwiftData


@Model
class DurationModel: Codable, Identifiable {
    
    enum CodingKeys: String, CodingKey {
        case startTime
        case endTime
    }
    
    var startTime: Int
    var startDate: Date {
        return Date(timeIntervalSince1970: TimeInterval(startTime))
    }
    
    var endTime: Int
    var endDate: Date {
        return Date(timeIntervalSince1970: TimeInterval(endTime))
    }
    
    var isValid: Bool {
        return Date() < endDate
    }
    
    init(startTime: Int, endTime: Int) {
        self.startTime = startTime
        self.endTime = endTime
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.startTime = try container.decode(Int.self, forKey: .startTime)
        self.endTime = try container.decode(Int.self, forKey: .endTime)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(endTime, forKey: .endTime)
    }

}
