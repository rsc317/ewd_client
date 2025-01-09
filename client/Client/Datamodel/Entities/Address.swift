//
//  Address.swift
//  client
//
//  Created by Emircan Duman on 06.11.24.
//

import Foundation
import SwiftData


struct Address: Codable, Identifiable, Equatable {
    enum CodingKeys: String, CodingKey {
        case street
        case streetNumber = "street_number"
        case postcode
        case city
        case state
        case country
    }
    
    let id = UUID()
    let streetName: String
    let streetNumber: String
    let postcode: String
    let city: String
    let state: String
    let country: String
    
    init(streetName: String, streetNumber: String, city: String, postcode: String, state: String, country: String) {
        self.streetName = streetName
        self.streetNumber = streetNumber
        self.city = city
        self.country = country
        self.state = state
        if postcode.isNumeric {
            self.postcode = postcode
        } else {
            self.postcode = "00000"
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        streetName = try container.decodeIfPresent(String.self, forKey: .street) ?? ""
        streetNumber = try container.decodeIfPresent(String.self, forKey: .streetNumber) ?? ""
        city = try container.decodeIfPresent(String.self, forKey: .city) ?? ""
        country = try container.decodeIfPresent(String.self, forKey: .country) ?? ""
        state = try container.decodeIfPresent(String.self, forKey: .state) ?? ""
        postcode = try container.decodeIfPresent(String.self, forKey: .postcode) ?? ""
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(streetName, forKey: .street)
        try container.encode(streetNumber, forKey: .streetNumber)
        try container.encode(city, forKey: .city)
        try container.encode(country, forKey: .country)
        try container.encode(state, forKey: .state)
        try container.encode(postcode, forKey: .postcode)
    }
    
    static func ==(lhs: Address, rhs: Address) -> Bool {
        return lhs.streetName == rhs.streetName &&
            lhs.streetNumber == rhs.streetNumber &&
            lhs.postcode == rhs.postcode &&
            lhs.city == rhs.city &&
            lhs.country == rhs.country
    }
    
    func isEmpty() -> Bool {
        streetName.isEmpty && city.isEmpty && country.isEmpty && postcode.isEmpty
    }
}
