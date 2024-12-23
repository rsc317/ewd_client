//
//  pinpointTest.swift
//  client
//
//  Created by Johannes Grothe on 23.12.24.
//

import Testing
import Foundation
import MapKit

@testable import struct client.PinPoint
import class client.Duration
import struct client.GeoCoordinate

struct PinPointTests {
    
    @Test func testInitializationWithRequiredProperties() async throws {
        // Arrange
        let title = "Test PinPoint"
        let description = "This is a test description"
        let duration = Duration(hours: 1, minutes: 30)
        let coordinate = GeoCoordinate(latitude: 52.5200, longitude: 13.4050)
        
        // Act
        let pinPoint = PinPoint(title: title, description: description, duration: duration, coordinate: coordinate)
        
        // Assert
        #expect(pinPoint.title == title, "Title should match the provided value")
        #expect(pinPoint.description == description, "Description should match the provided value")
        #expect(pinPoint.duration == duration, "Duration should match the provided value")
        #expect(pinPoint.coordinate.latitude == coordinate.latitude, "Coordinate latitude should match the provided value")
        #expect(pinPoint.coordinate.longitude == coordinate.longitude, "Coordinate longitude should match the provided value")
    }
    
    @Test func testDecodingFromJSON() async throws {
        // Arrange
        let json = """
        {
            "id": 1,
            "title": "Test PinPoint",
            "description": "This is a test description",
            "is_deleted": false,
            "duration": {
                "start_time": 1234567890,
                "end_time": 1234567890
            },
            "coordinate": {
                "latitude": 52.5200,
                "longitude": 13.4050
            }
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        
        // Act
        let pinPoint = try decoder.decode(PinPoint.self, from: json)
        
        // Assert
        #expect(pinPoint.title == "Test PinPoint", "Decoded title should match JSON value")
        #expect(pinPoint.description == "This is a test description", "Decoded description should match JSON value")
        #expect(pinPoint.isDeleted == false, "Decoded isDeleted should match JSON value")
        #expect(pinPoint.coordinate.latitude == 52.5200, "Decoded latitude should match JSON value")
        #expect(pinPoint.coordinate.longitude == 13.4050, "Decoded longitude should match JSON value")
    }
    
    @Test func testEncodingToJSON() async throws {
        // Arrange
        let title = "Test PinPoint"
        let description = "This is a test description"
        let duration = Duration(hours: 1, minutes: 30)
        let coordinate = GeoCoordinate(latitude: 52.5200, longitude: 13.4050)
        let pinPoint = PinPoint(title: title, description: description, duration: duration, coordinate: coordinate)
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        // Act
        let encodedData = try encoder.encode(pinPoint)
        let jsonString = String(data: encodedData, encoding: .utf8)!
        
        // Assert
        #expect(jsonString.contains("\"title\" : \"Test PinPoint\""), "JSON should contain correct title")
        #expect(jsonString.contains("\"description\" : \"This is a test description\""), "JSON should contain correct description")
        #expect(jsonString.contains("\"latitude\" : 52.52"), "JSON should contain correct latitude")
        #expect(jsonString.contains("\"longitude\" : 13.405"), "JSON should contain correct longitude")
    }
    
    @Test func testGetPrettyPrint() async throws {
        // Arrange
        let coordinate = GeoCoordinate(latitude: 52.5200, longitude: 13.4050)
        let pinPoint = PinPoint(title: "Test PinPoint", description: "This is a test description", duration: Duration(hours: 1, minutes: 30), coordinate: coordinate)
        
        // Act
        let prettyPrint = pinPoint.getPrettyPrint()
        
        // Assert
        #expect(prettyPrint == "52.520000 / 13.405000", "Pretty print should format coordinates correctly")
    }
    
    @Test func testMockFunctionCreatesValidPinPoint() async throws {
        // Arrange
        let coordinate = GeoCoordinate(latitude: 52.5200, longitude: 13.4050)
        let duration = Duration(hours: 1, minutes: 30)
        let pinPoint = PinPoint(title: "Mock PinPoint", description: "Mock description", duration: duration, coordinate: coordinate)
        
        // Assert
        #expect(pinPoint.title == "Mock PinPoint", "Mock PinPoint should have correct title")
        #expect(pinPoint.description == "Mock description", "Mock PinPoint should have correct description")
        #expect(pinPoint.coordinate.latitude == 52.5200, "Mock PinPoint should have correct latitude")
        #expect(pinPoint.coordinate.longitude == 13.4050, "Mock PinPoint should have correct longitude")
    }
}
