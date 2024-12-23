//
//  commentTest.swift
//  client
//
//  Created by Johannes Grothe on 23.12.24.
//

import Testing
import Foundation

@testable import struct client.Comment

struct CommentTests {
    
    @Test func testInitializationWithContent() async throws {
        // Arrange
        let content = "This is a test comment."
        
        // Act
        let comment = Comment(content: content)
        
        // Assert
        #expect(comment.content == content, "Content should match the provided value")
        #expect(comment.username == nil, "Username should be nil when not provided")
        #expect(abs(comment.createdAt.timeIntervalSinceNow) < 1, "CreatedAt should be approximately now")
        #expect(comment.id != nil, "ID should be automatically generated")
    }
    
    @Test func testDecodingFromJSON() async throws {
        // Arrange
        let json = """
        {
            "content": "This is a JSON-decoded comment.",
            "username": "TestUser",
            "created_at": "2024-12-23T12:00:00.000000"
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        // Act
        let comment = try decoder.decode(Comment.self, from: json)
        
        // Assert
        #expect(comment.content == "This is a JSON-decoded comment.", "Decoded content should match JSON")
        #expect(comment.username == "TestUser", "Decoded username should match JSON")
        #expect(comment.createdAt == Comment.dateFormatter.date(from: "2024-12-23T12:00:00.000000"),
                "Decoded createdAt should match JSON date")
    }
    
    @Test func testEncodingToJSON() async throws {
        // Arrange
        let content = "This is a comment to encode."
        let username = "EncoderTestUser"
        let createdAt = Comment.dateFormatter.date(from: "2024-12-23T12:00:00.000000")!
        var comment = Comment(content: content)
        comment.username = username
        comment.createdAt = createdAt
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        // Act
        let encodedData = try encoder.encode(comment)
        let jsonString = String(data: encodedData, encoding: .utf8)!
        
        // Assert
        #expect(jsonString.contains("\"content\" : \"\(content)\""), "JSON should contain correct content")
        #expect(jsonString.contains("\"username\" : \"\(username)\""), "JSON should contain correct username")
        #expect(jsonString.contains("\"created_at\" : \"2024-12-23T12:00:00.000000\""), "JSON should contain correct createdAt")
    }
    
    @Test func testInvalidDateFormatDecoding() async throws {
        // Arrange
        let json = """
        {
            "content": "Invalid date format test.",
            "username": "TestUser",
            "created_at": "12-23-2024 12:00:00"
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        // Act & Assert
        do {
            _ = try decoder.decode(Comment.self, from: json)
            #expect(Bool(false), "Decoding should throw an error for an invalid date format")
        } catch {
            #expect(Bool(true), "Decoding failed as expected with an invalid date format")
        }
    }
    
    @Test func testDefaultDateFormatter() async throws {
        // Arrange
        let expectedFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        
        // Act
        let formatter = Comment.dateFormatter
        
        // Assert
        #expect(formatter.dateFormat == expectedFormat, "DateFormatter should have the correct format")
        #expect(formatter.locale.identifier == "en_US_POSIX", "DateFormatter locale should be en_US_POSIX")
        #expect(formatter.timeZone.secondsFromGMT() == 0, "DateFormatter time zone should be GMT")
    }
}
