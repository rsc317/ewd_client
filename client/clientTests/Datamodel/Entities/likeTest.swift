//
//  likeTest.swift
//  client
//
//  Created by Johannes Grothe on 23.12.24.
//

import Testing
import Foundation

@testable import struct client.Like

struct LikeTests {
    
    @Test func testInitialization() async throws {
        // Arrange
        let like = Like(isLike: true)
        
        // Assert
        #expect(like.isLike == true, "isLike should match the provided value")
        
        // Act
        let dislike = Like(isLike: false)
        
        // Assert
        #expect(dislike.isLike == false, "isLike should match the provided value")
    }
    
    @Test func testDecodingFromJSON() async throws {
        // Arrange
        let json = """
        {
            "is_like": true
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        // Act
        let like = try decoder.decode(Like.self, from: json)
        
        // Assert
        #expect(like.isLike == true, "Decoded isLike should match JSON value")
    }
    
    @Test func testEncodingToJSON() async throws {
        // Arrange
        let isLike: Bool = false
        let like = Like(isLike: isLike)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        // Act
        let encodedData = try encoder.encode(like)
        let jsonString = String(data: encodedData, encoding: .utf8)!
        
        // Assert
        #expect(jsonString.contains("\"is_like\" : false"), "JSON should contain correct is_like value")
    }
}
