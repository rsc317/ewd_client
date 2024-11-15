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
    
    func fetchAllPinPoints() async throws {
        
    }
    
    func postPinPoint(_ locationCoordinates: CLLocationCoordinate2D) async throws {
        
    }
    
    func addMockPinPoint(_ locationCoordinates: CLLocationCoordinate2D) {
        pinPoints.append(createMock(lattiude: locationCoordinates.latitude, longitude: locationCoordinates.longitude))
    }
    
//    private func createPinPoint(geoCoordinate: GeoCoordinate, duration: Duration, user: User) -> PinPoint {
//            
//    }
//    
//    private func createGeoCoordinate(_ locationCoordinates: CLLocationCoordinate2D) -> GeoCoordinate {
//        
//    }
//    
//    private func getLoggedUser() -> User {
//        
//    }
    
    private func createMock(lattiude: Double, longitude: Double) -> PinPoint {
        return PinPoint(title: "MockTitle", body: "MockBody", isDeleted: false, user: .mock(), duration: .mock(), geoCoordinate: .mock(lattitude: lattiude, longitude: longitude))
    }
    
}
