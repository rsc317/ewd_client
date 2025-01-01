//
//  authenticationTokenTest.swift
//  client
//
//  Created by Johannes Grothe on 23.12.24.
//

import Testing
import Foundation

@testable import struct client.AuthenticationToken

struct AuthenticationTokenTests {
    
    @Test func testInitializationWithValidData() async throws {
        // Arrange
        let token = "validToken123"
        let expiresIn: Double = 60000 // 1 minute in milliseconds
        let userVerified = true
        
        // Act
        let authToken = AuthenticationToken(token: token, expiresIn: expiresIn, userVerified: userVerified)
        
        // Assert
        #expect(authToken.token == token, "Token should match")
        #expect(authToken.userVerified == userVerified, "User verified status should match")
        #expect(abs(authToken.expireDate.timeIntervalSinceNow - 60) < 1, "Expire date should be approximately 60 seconds from now")
        #expect(authToken.id != nil, "ID should be automatically generated")
    }
    
    @Test func testInitializationWithDecoder() async throws {
        // Arrange
        let json = """
        {
            "token": "decodedToken123",
            "expires_in": 120000,
            "user_verified": true
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        // Act
        let authToken = try decoder.decode(AuthenticationToken.self, from: json)
        
        // Assert
        #expect(authToken.token == "decodedToken123", "Decoded token should match JSON")
        #expect(authToken.userVerified == true, "Decoded userVerified status should match JSON")
        #expect(abs(authToken.expireDate.timeIntervalSinceNow - 120) < 1, "Expire date should match JSON expires_in value")
    }
    
    @Test func testEncodingToJSON() async throws {
        // Arrange
        let token = "encodedToken456"
        let expiresIn: Double = 30000 // 30 seconds in milliseconds
        let userVerified = false
        let authToken = AuthenticationToken(token: token, expiresIn: expiresIn, userVerified: userVerified)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        // Act
        let encodedData = try encoder.encode(authToken)
        let jsonString = String(data: encodedData, encoding: .utf8)!
        
        // Assert
        #expect(jsonString.contains("\"token\" : \"\(token)\""), "JSON should contain correct token")
        #expect(jsonString.contains("\"user_verified\" : \(userVerified)"), "JSON should contain correct userVerified status")
        #expect(jsonString.contains("\"expires_in\""), "JSON should contain expires_in field")
    }
    
    @Test func testExpireDateCalculation() async throws {
        // Arrange
        let token = "testToken789"
        let expiresIn: Double = -5000 // Expired 5 seconds ago
        let userVerified = true
        
        // Act
        let authToken = AuthenticationToken(token: token, expiresIn: expiresIn, userVerified: userVerified)
        
        // Assert
        #expect(authToken.expireDate.timeIntervalSinceNow < 0, "Expire date should be in the past")
    }
}
