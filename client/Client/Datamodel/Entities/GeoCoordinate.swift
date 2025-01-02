//
//  Geocoordinate.swift
//  client
//
//  Created by Emircan Duman on 06.11.24.
//

import Foundation
import SwiftData
import MapKit


struct GeoCoordinate: Codable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case address
    }
    
    let id = UUID()
    let latitude: Double
    let longitude: Double
    var address: Address?
    
    var coordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init (latitude: Double, longitude: Double, address: Address? = nil) {
        self.latitude = latitude
        self.longitude = longitude
        if let address {
            self.address = address
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
        self.address = try container.decodeIfPresent(Address.self , forKey: .address)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        if let address = address {
            try container.encode(address, forKey: .address)
        }
    }
    
    static func mock(latitude: Double = 52.5200, longitude: Double = 13.4050) -> GeoCoordinate {
        return GeoCoordinate(latitude: latitude, longitude: longitude)
    }
}
