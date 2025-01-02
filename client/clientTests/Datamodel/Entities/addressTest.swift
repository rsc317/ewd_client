//
//  addressTest.swift
//  client
//
//  Created by Johannes Grothe on 23.12.24.
//

import Testing
import Foundation

@testable import struct client.Address

struct addressTests {
    
    @Test func testInitializationWithValidData() async throws {
        // Arrange
        let streetName = "Main Street"
        let streetNumber = "123"
        let city = "Berlin"
        let postcode = "10115"
        let country = "Germany"
        
        // Act
        let address = Address(streetName: streetName, streetNumber: streetNumber, city: city, postcode: postcode, country: country)
        
        // Assert
        #expect(address.streetName == streetName, "Street name should match")
        #expect(address.streetNumber == streetNumber, "Street number should match")
        #expect(address.city == city, "City should match")
        #expect(address.postcode == postcode, "Postcode should match")
        #expect(address.country == country, "Country should match")
        #expect(address.id != nil, "ID should be automatically generated")
    }
    
    @Test func testInitializationWithInvalidPostcode() async throws {
        // Arrange
        let streetName = "Main Street"
        let streetNumber = "123"
        let city = "Berlin"
        let invalidPostcode = "AB123"
        let country = "Germany"
        
        // Act
        let address = Address(streetName: streetName, streetNumber: streetNumber, city: city, postcode: invalidPostcode, country: country)
        
        // Assert
        #expect(address.postcode == "00000", "Invalid postcode should default to '00000'")
    }
    
    @Test func testEncodingAndDecoding() async throws {
        // Arrange
        let streetName = "Main Street"
        let streetNumber = "123"
        let city = "Berlin"
        let postcode = "10115"
        let country = "Germany"
        let address = Address(streetName: streetName, streetNumber: streetNumber, city: city, postcode: postcode, country: country)
        
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        // Act
        let encodedData = try encoder.encode(address)
        let decodedAddress = try decoder.decode(Address.self, from: encodedData)
        
        // Assert
        #expect(decodedAddress.streetName == address.streetName, "Street name should be preserved after encoding/decoding")
        #expect(decodedAddress.streetNumber == address.streetNumber, "Street number should be preserved after encoding/decoding")
        #expect(decodedAddress.city == address.city, "City should be preserved after encoding/decoding")
        #expect(decodedAddress.postcode == address.postcode, "Postcode should be preserved after encoding/decoding")
        #expect(decodedAddress.country == address.country, "Country should be preserved after encoding/decoding")
    }
    
    @Test func testCodingKeys() async throws {
        // Arrange
        let json = """
    {
        "street_name": "Main Street",
        "street_number": "123",
        "postcode": "10115",
        "city": "Berlin",
        "country": "Germany"
    }
    """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        
        // Act
        let address = try decoder.decode(Address.self, from: json)
        
        // Assert
        #expect(address.streetName == "Main Street", "Decoded street name should match JSON")
        #expect(address.streetNumber == "123", "Decoded street number should match JSON")
        #expect(address.city == "Berlin", "Decoded city should match JSON")
        #expect(address.postcode == "10115", "Decoded postcode should match JSON")
        #expect(address.country == "Germany", "Decoded country should match JSON")
    }
    
    @Test func testAddressEqualityExcludingID() {
        // Erstelle zwei gleiche Address-Instanzen mit unterschiedlichen IDs
        let address1 = Address(streetName: "Main Street", streetNumber: "123", city: "Berlin", postcode: "10115", country: "Germany")
        let address2 = Address(streetName: "Main Street", streetNumber: "123", city: "Berlin", postcode: "10115", country: "Germany")
        
        // Die IDs sollten unterschiedlich sein
        #expect(address1.id != address2.id, "Die IDs der Adressen sollten unterschiedlich sein.")
        
        // Der Vergleich ohne die IDs sollte jedoch wahr sein
        #expect(address1 == address2, "Die Adressen sollten gleich sein, wenn man die ID ignoriert.")
    }
}
