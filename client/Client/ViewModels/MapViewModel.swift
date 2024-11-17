//
//  MapViewModel.swift
//  client
//
//  Created by Emircan Duman on 14.11.24.
//

import Foundation
import SwiftUI
import MapKit


@Observable
class MapViewModel {
    private(set) var pinPoints: [PinPoint] = []
    var selectedPinPoint: PinPoint?
    var isLoading: Bool = false
    var errorMessage: String?
    
    func fetchAllPinPoints() async throws {
        
    }
    
    func createPinPoint(
        locationCoordinates: CLLocationCoordinate2D?,
        title: String,
        description: String,
        minutes: Double,
        hours: Double,
        imagesResponses: [ImageResponse]
    ) async throws {
        isLoading = true
        errorMessage = nil
        
        guard let locationCoordinates = locationCoordinates else { throw MapError.nilObject("Locations is Nil!") }
        guard let user = AuthenticationManager.shared.currentUser else { throw MapError.notAuthentificated("User is not logged in!") }
        
        let duration = Duration(hours: hours, minutes: minutes)
        let geoCoordinates = GeoCoordinate(lattitude: locationCoordinates.latitude, longitude: locationCoordinates.longitude, radius: 20)
        let newPinPoint: PinPoint = PinPoint(title: title, description: description, user: user, duration: duration, geoCoordinate: geoCoordinates)
        
        do {
            let _: PinPoint = try await APIService.shared.post(endpoint: "/pinpoints", body: newPinPoint)
        } catch {
            if let apiError = error as? APIError {
                self.errorMessage = apiError.localizedDescription
            } else {
                self.errorMessage = error.localizedDescription
            }
        }
        
        isLoading = false
    }
    
    func addMockPinPoint(_ locationCoordinates: CLLocationCoordinate2D) {
        pinPoints.append(createMock(lattiude: locationCoordinates.latitude, longitude: locationCoordinates.longitude))
    }
    
    private func createMock(lattiude: Double, longitude: Double) -> PinPoint {
        return PinPoint(title: "MockTitle", description: "MockBody", user: .mock(), duration: .mock(), geoCoordinate: .mock(lattitude: lattiude, longitude: longitude))
    }
    
}

enum MapError: Error {
    case nilObject(String)
    case notAuthentificated(String)
}
