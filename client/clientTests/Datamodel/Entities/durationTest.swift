//
//  durationTest.swift
//  client
//
//  Created by Johannes Grothe on 23.12.24.
//

import Testing
import Foundation

@testable import client

struct DurationTests {
    
    @Test func testInitializationWithHoursAndMinutes() async throws {
        // Arrange
        let hours: Double = 2.0
        let minutes: Double = 30.0
        let expectedDurationInSeconds = (hours * 3600 + minutes * 60)
        
        // Act
        let duration = Duration(hours: hours, minutes: minutes)
        
        // Assert
        #expect(abs(duration.startDate.timeIntervalSinceNow) < 1, "Start date should be approximately now")
        #expect((abs(duration.endDate.timeIntervalSinceNow) - expectedDurationInSeconds) < 1,
                "End date should be \(expectedDurationInSeconds) seconds from now")
    }
    
    @Test func testIsValidReturnsTrueForFutureEndDate() async throws {
        // Arrange
        let duration = Duration(hours: 1.0, minutes: 0.0)
        
        // Assert
        #expect(duration.isValid == true, "isValid should return true for a future end date")
    }
    
    @Test func testIsValidReturnsFalseForPastEndDate() async throws {
        // Arrange
        let duration = Duration(hours: -1.0, minutes: 0.0) // End date is in the past
        
        // Assert
        #expect(duration.isValid == false, "isValid should return false for a past end date")
    }
    
    @Test func testDecodingFromJSON() async throws {
        // Arrange
        let startTime: Double = Date().timeIntervalSince1970
        let endTime: Double = startTime + 3600 // 1 hour later
        let json = """
        {
            "start_time": \(startTime),
            "end_time": \(endTime)
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        // Act
        let duration = try decoder.decode(Duration.self, from: json)
        
        // Assert
        #expect(duration.startDate.timeIntervalSince1970 == startTime,
                "Decoded start time should match JSON value")
        #expect(duration.endDate.timeIntervalSince1970 == endTime,
                "Decoded end time should match JSON value")
    }
    
    @Test func testEncodingToJSON() async throws {
        // Arrange
        let hours: Double = 1.5
        let minutes: Double = 0.0
        let duration = Duration(hours: hours, minutes: minutes)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        // Act
        let encodedData = try encoder.encode(duration)
        let jsonString = String(data: encodedData, encoding: .utf8)!
        
        // Assert
        #expect(jsonString.contains("\"start_time\""), "JSON should contain start_time field")
        #expect(jsonString.contains("\"end_time\""), "JSON should contain end_time field")
    }
}
