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
    var isLoading: Bool = false
    var errorMessage: String?

    func fetchAllPinPoints() async throws {
        pinPoints = []
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedPins: [PinPoint] = try await APIService.shared.get(endpoint: "pinpoints", queryParameters: self.getQueryParamsForPinPoint())
            pinPoints.append(contentsOf: fetchedPins)
        } catch {
            if let apiError = error as? APIError {
                self.errorMessage = apiError.localizedDescription
            } else {
                self.errorMessage = error.localizedDescription
            }
        }
        
        isLoading = false
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
        
        let duration = Duration(hours: hours, minutes: minutes)
        let geoCoordinates = GeoCoordinate(latitude: locationCoordinates.latitude, longitude: locationCoordinates.longitude)
        let newPinPoint: PinPoint = PinPoint(title: title, description: description, duration: duration, coordinate: geoCoordinates)
        
        do {
            let returnedPinPoint:PinPoint = try await APIService.shared.post(endpoint: "pinpoints", body: newPinPoint)
            print("saving pinpoint \(returnedPinPoint.serverId) on server)")
            guard let serverID = returnedPinPoint.serverId else { throw MapError.nilObject("ServerID is Nil!") }
            let responseMsg:String = try await APIService.shared.post(endpoint: "pinpoints/\(serverID)/images", body: imagesResponses)
            print("server msg:\(responseMsg)")
        } catch {
            if let apiError = error as? APIError {
                self.errorMessage = apiError.localizedDescription	
            } else {
                self.errorMessage = error.localizedDescription
            }
            print("saving pinpoint failed:\(self.errorMessage!)")
        }
        Task {
            do {
                try await self.fetchAllPinPoints()
            } catch {
                print("Fehler beim Laden der Daten: \(error)")
            }
        }
        isLoading = false
    }
    
    private func getQueryParamsForPinPoint() -> [String:String] {
        let radiusValue: Double = UserDefaults.standard.double(forKey: "radiusValue")

        guard let latitue = LocationManager.shared.getCurrentLocation()?.coordinate.latitude else {
            return [:]
        }
        guard let longitude = LocationManager.shared.getCurrentLocation()?.coordinate.longitude else {
            return [:]
        }
        return ["latitude": String(latitue), "longitude": String(longitude), "radius": String(radiusValue)]
    }
    
    func addMockPinPoint(_ locationCoordinates: CLLocationCoordinate2D) {
        pinPoints.append(createMock(lattiude: locationCoordinates.latitude, longitude: locationCoordinates.longitude))
    }
    
    private func createMock(lattiude: Double, longitude: Double) -> PinPoint {
        let duration = Duration(hours: 3, minutes: 30)
        return PinPoint(title: "MockTitle", description: "MockBody", duration: duration, coordinate: .mock(latitude: lattiude, longitude: longitude))
    }
}

enum MapError: Error {
    case nilObject(String)
    case notAuthentificated(String)
}
