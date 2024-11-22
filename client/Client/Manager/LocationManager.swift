//
//  LocationManager.swift
//  client
//
//  Created by Emircan Duman on 14.11.24.
//

import SwiftUI
import MapKit
import Observation

@Observable
final class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    var region = MKCoordinateRegion()
    var authorizationDenied: Bool = false
    
    var locationUpdateHandler: ((CLLocation) -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            print("Location access is restricted")
        case .denied:
            authorizationDenied = true
            print("Location access was denied")
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            authorizationDenied = false
            requestLocation()
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        currentLocation = location
        
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        
        locationUpdateHandler?(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Fehler beim Abrufen des Standorts: \(error.localizedDescription)")
    }
    
    func getCurrentLocation() -> CLLocation? {
        return currentLocation
    }
}
