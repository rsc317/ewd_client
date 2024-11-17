//
//  MapView.swift
//  client
//
//  Created by Emircan Duman on 10.11.24.
//

import SwiftUI
import MapKit


struct MapView: View {
    @State private var mapViewModel = MapViewModel()
    @State private var locationManager = LocationManager.shared
    @State private var position = MapCameraPosition.userLocation(followsHeading: true, fallback: .automatic)
    @State private var showCreatePinPointSheet = false
    @State private var showSettingsAlert: Bool = false
    @State var pinLocation: CLLocationCoordinate2D?

    var body: some View {
        VStack {
            MapReader { reader in
                Map(position: $position) {
                    UserAnnotation()
                    ForEach(mapViewModel.pinPoints, id: \.id) { pinPoint in
                        Annotation(pinPoint.title, coordinate: pinPoint.geoCoordinate.coordinates) {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundStyle(Color("IconColor"))
                                .padding()
                                .font(.system(size: 25))

                        }
                    }
                }
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                    MapScaleView()
                }
                .onTapGesture { screenCoord in
                    handleTapGesture(screenCoord: screenCoord, reader: reader)
                }
            }
        }
        .sheet(isPresented: $showCreatePinPointSheet) {
            CreatePinPointSheetView(mapViewModel: $mapViewModel, pinLocation: $pinLocation)
                .presentationDragIndicator(.visible)
        }
        .onChange(of: locationManager.authorizationDenied) { _ , newValue in
            showSettingsAlert = newValue
        }
        .onAppear(perform: {
            locationManager.requestLocation()
            Task {
                do {
                    try await mapViewModel.fetchAllPinPoints()
                } catch {
                    print("Fehler beim Laden der Daten: \(error)")
                }
            }
        })
        .alert("Standortzugriff benötigt",
               isPresented: $showSettingsAlert,
               actions: {
            Button("Einstellungen öffnen") {
                openAppSettings()
            }
            Button("Abbrechen", role: .cancel) { }
        },
               message: {
            Text("Bitte erlauben Sie den Standortzugriff in den Einstellungen, um die App nutzen zu können.")
        })
    }
    
    func handleTapGesture(screenCoord: CGPoint, reader: MapProxy) {
        if let pinLocation = reader.convert(screenCoord, from: .local) {
            self.pinLocation = pinLocation
            showCreatePinPointSheet = true && !locationManager.authorizationDenied
            showSettingsAlert = locationManager.authorizationDenied
        }
    }
    
    func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}

#Preview {
    MapView()
}
