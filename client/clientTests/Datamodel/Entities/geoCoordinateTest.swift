//
//  geoCoordinateTest.swift
//  client
//
//  Created by Johannes Grothe on 23.12.24.
//

import Testing
import Foundation
import MapKit

@testable import client

struct GeoCoordinateTests {
    
    @Test func testInitializationWithCoordinates() async throws {
        // Arrange
        let latitude: Double = 52.5200
        let longitude: Double = 13.4050
        
        // Act
        let geoCoordinate = GeoCoordinate(latitude: latitude, longitude: longitude)
        
        // Assert
        #expect(geoCoordinate.latitude == latitude, "Latitude should match the provided value")
        #expect(geoCoordinate.longitude == longitude, "Longitude should match the provided value")
        #expect(geoCoordinate.address == nil, "Address should be nil when not provided")
    }
    
    @Test func testInitializationWithCoordinatesAndAddress() async throws {
        // Arrange
        let latitude: Double = 52.5200
        let longitude: Double = 13.4050
        let address = Address(streetName: "Test Street", streetNumber: "123", city: "Berlin", postcode: "10115", country: "Germany")
        
        // Act
        let geoCoordinate = GeoCoordinate(latitude: latitude, longitude: longitude, address: address)
        
        // Assert
        #expect(geoCoordinate.latitude == latitude, "Latitude should match the provided value")
        #expect(geoCoordinate.longitude == longitude, "Longitude should match the provided value")
        #expect(geoCoordinate.address == address, "Address should match the provided address")
    }
    
    @Test func testCoordinatesProperty() async throws {
        // Arrange
        let latitude: Double = 52.5200
        let longitude: Double = 13.4050
        let geoCoordinate = GeoCoordinate(latitude: latitude, longitude: longitude)
        
        // Act
        let coordinates = geoCoordinate.coordinates
        
        // Assert
        #expect(coordinates.latitude == latitude, "Coordinates latitude should match the provided value")
        #expect(coordinates.longitude == longitude, "Coordinates longitude should match the provided value")
    }
    
    @Test func testDecodingFromJSON() async throws {
        // Arrange
        let json = """
        {
            "latitude": 52.5200,
            "longitude": 13.4050,
            "address": {
                "street_name": "Test Street",
                "street_number": "123",
                "city": "Berlin",
                "postcode": "10115",
                "country": "Germany"
            }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        // Act
        let geoCoordinate = try decoder.decode(GeoCoordinate.self, from: json)
        
        // Assert
        #expect(geoCoordinate.latitude == 52.5200, "Decoded latitude should match JSON value")
        #expect(geoCoordinate.longitude == 13.4050, "Decoded longitude should match JSON value")
        #expect(geoCoordinate.address?.city == "Berlin", "Decoded address city should match JSON value")
    }
    
    @Test func testEncodingToJSON() async throws {
        // Arrange
        let latitude: Double = 52.5200
        let longitude: Double = 13.4050
        let address = Address(streetName: "Test Street", streetNumber: "123", city: "Berlin", postcode: "10115", country: "Germany")
        let geoCoordinate = GeoCoordinate(latitude: latitude, longitude: longitude, address: address)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        // Act
        let encodedData = try encoder.encode(geoCoordinate)
        let jsonString = String(data: encodedData, encoding: .utf8)!
        
        // Assert
        #expect(jsonString.contains("\"latitude\" : \(latitude)"), "JSON should contain correct latitude")
        #expect(jsonString.contains("\"longitude\" : \(longitude)"), "JSON should contain correct longitude")
        #expect(jsonString.contains("\"street_name\" : \"Test Street\""), "JSON should contain correct street name")
        #expect(jsonString.contains("\"city\" : \"Berlin\""), "JSON should contain correct city")
    }
}
