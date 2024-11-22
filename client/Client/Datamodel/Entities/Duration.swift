//
//  Duration.swift
//  client
//
//  Created by Emircan Duman on 06.11.24.
//

import Foundation
import SwiftData


@Model
class Duration: Codable, Identifiable {
    
    enum CodingKeys: String, CodingKey {
        case startTime = "start_time"
        case endTime = "end_time"
    }
    
    private var startTime: Double
    var startDate: Date {
        return Date(timeIntervalSince1970: TimeInterval(startTime))
    }
    
    private var endTime: Double
    var endDate: Date {
        return Date(timeIntervalSince1970: TimeInterval(endTime))
    }
    
    var isValid: Bool {
        return Date() < endDate
    }
    
    init(hours: Double, minutes: Double) {
        self.startTime = Date().timeIntervalSince1970
        self.endTime = Date().timeIntervalSince1970 + (hours+minutes)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.startTime = try container.decode(Double.self, forKey: .startTime)
        self.endTime = try container.decode(Double.self, forKey: .endTime)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(endTime, forKey: .endTime)
    }
    
    static func mock() -> Duration {
        return Duration(hours: 2.0, minutes: 30.0)
    }
}
