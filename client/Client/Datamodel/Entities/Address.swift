//
//  Address.swift
//  client
//
//  Created by Emircan Duman on 06.11.24.
//

import Foundation
import SwiftData

@Model
class Address: Codable, Identifiable {
    
    enum CodingKeys: String, CodingKey {
        case streetName
        case streetNumber
        case city
        case country
        case zipCode
        case geoCoordinate
    }
    
    var streetName: String
    var streetNumber: String
    var city: String
    var country: String
    var zipCode: String {
        didSet {
            if !zipCode.isNumeric {
                print("Invalid value: Only numeric characters are allowed.")
                zipCode = oldValue
            }
        }
    }
    var geoCoordinate: GeoCoordinate
    
    init(streetName: String, streetNumber: String, city: String, zipCode: String, country: String, geocoordinate: GeoCoordinate) {
        self.streetName = streetName
        self.streetNumber = streetNumber
        self.city = city
        self.country = country
        self.geoCoordinate = geocoordinate
        if zipCode.isNumeric {
            self.zipCode = zipCode
        } else {
            print("Invalid initial value: Only numeric characters are allowed.")
            self.zipCode = ""
        }
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        streetName = try container.decode(String.self, forKey: .streetName)
        streetNumber = try container.decode(String.self, forKey: .streetNumber)
        city = try container.decode(String.self, forKey: .city)
        country = try container.decode(String.self, forKey: .country)
        zipCode = try container.decode(String.self, forKey: .zipCode)
        geoCoordinate = try container.decode(GeoCoordinate.self, forKey: .geoCoordinate)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(streetName, forKey: .streetName)
        try container.encode(streetNumber, forKey: .streetNumber)
        try container.encode(city, forKey: .city)
        try container.encode(country, forKey: .country)
        try container.encode(zipCode, forKey: .zipCode)
        try container.encode(geoCoordinate, forKey: .geoCoordinate)
    }
}
