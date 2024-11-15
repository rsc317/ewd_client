//
//  Geocoordinate.swift
//  client
//
//  Created by Emircan Duman on 06.11.24.
//

import Foundation
import SwiftData
import MapKit


@Model
class GeoCoordinate: Codable, Identifiable {
    
    enum CodingKeys: String, CodingKey {
        case lattitude
        case longitude
        case radius
        case address
    }
    
    private var lattitude: Double
    private var longitude: Double
    var radius: Double
    @Relationship(deleteRule: .cascade, inverse: \Address.geoCoordinate) var address: Address?
    
    var coordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)
    }

    init (lattitude: Double, longitude: Double, radius: Double, address: Address? = nil) {
        self.lattitude = lattitude
        self.longitude = longitude
        self.radius = radius
        if let address {
            self.address = address
        }
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.lattitude = try container.decode(Double.self, forKey: .lattitude)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
        self.radius = try container.decode(Double.self, forKey: .radius)
        self.address = try container.decodeIfPresent(Address.self , forKey: .address)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(lattitude, forKey: .lattitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(radius, forKey: .radius)
        if let address = address {
            try container.encode(address, forKey: .address)
        }
    }
    
    static func mock(lattitude: Double = 52.5200, longitude: Double = 13.4050) -> GeoCoordinate {
        return GeoCoordinate(lattitude: lattitude, longitude: longitude, radius: 1000)
    }
}
