//
//  GeocoordinateModel.swift
//  client
//
//  Created by Emircan Duman on 06.11.24.
//

import Foundation
import SwiftData


@Model
class GeoCoordinateModel: Codable, Identifiable {
    
    enum CodingKeys: String, CodingKey {
        case lattitude
        case longitude
        case radius
        case address
        case pinPoint
    }
    
    var lattitude: Double
    var longitude: Double
    var radius: Double
    var pinPoint: PinPointModel
    @Relationship(deleteRule: .cascade, inverse: \AddressModel.geoCoordinate) var address: AddressModel?

    init (lattitude: Double, longitude: Double, radius: Double, pinPoint: PinPointModel, address: AddressModel? = nil) {
        self.lattitude = lattitude
        self.longitude = longitude
        self.radius = radius
        self.pinPoint = pinPoint
        if let address {
            self.address = address
        }
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.lattitude = try container.decode(Double.self, forKey: .lattitude)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
        self.radius = try container.decode(Double.self, forKey: .radius)
        self.pinPoint = try container.decode(PinPointModel.self, forKey: .pinPoint)
        self.address = try container.decodeIfPresent(AddressModel.self , forKey: .address)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(lattitude, forKey: .lattitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(radius, forKey: .radius)
        try container.encode(pinPoint, forKey: .pinPoint)
        if let address = address {
            try container.encode(address, forKey: .address)
        }
    }
}
