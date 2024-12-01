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
    @State private var selectedPinPoint: PinPoint?
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
                        Annotation(pinPoint.title, coordinate: pinPoint.coordinate.coordinates) {
                            VStack{
                                Button(action: {
                                    pinPointPressed(pinPoint)
                                }) {
                                    Image(systemName: "mappin.and.ellipse.circle")
                                        .resizable()
                                        .foregroundStyle(Color("IconColor"))
                                        .frame(width: 40, height: 40)
                                        .background(Color.white)
                                        .clipShape(Circle())
                                        .shadow(color: .black.opacity(0.3), radius: 6, x: 2, y: 2)
                                }
                            }
                        }
                    }
                }
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                    MapScaleView()
                }
                .gesture(//Dirtyhack
                    LongPressGesture(minimumDuration: 0.2)
                        .sequenced(before: DragGesture(minimumDistance: 0, coordinateSpace: .global))
                        .onEnded { value in
                            switch value {
                            case .second(true, let drag?):
                                let location = drag.location
                                handleTapGesture(screenCoord: location, reader: reader)
                            default:
                                break
                            }
                        }
                )
            }
        }
        .sheet(isPresented: $showCreatePinPointSheet) {
            CreatePinPointSheetView(mapViewModel: $mapViewModel, pinLocation: $pinLocation)
                .presentationDragIndicator(.visible)
        }
        .sheet(item: $selectedPinPoint) { pinPoint in
            DetailPinPointView(pinPoint: pinPoint)
        }
        .onChange(of: locationManager.authorizationDenied) { _ , newValue in
            showSettingsAlert = newValue
        }
        .onAppear(perform: {
            locationManager.requestLocation()
            fetchPinPoints()
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
    
    private func pinPointPressed(_ pinPoint: PinPoint) {
        selectedPinPoint = pinPoint
        print("Selected PinPoint: \(pinPoint.title)")
    }
    
    private func handleTapGesture(screenCoord: CGPoint, reader: MapProxy) {
        if let pinLocation = reader.convert(screenCoord, from: .local) {
            self.pinLocation = pinLocation
            showCreatePinPointSheet = true && !locationManager.authorizationDenied
            showSettingsAlert = locationManager.authorizationDenied
        }
    }
    
    private func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    private func fetchPinPoints() {
        Task {
            do {
                try await mapViewModel.fetchAllPinPoints()
            } catch {
                print("Fehler beim Laden der Daten: \(error)")
            }
        }
    }
}

#Preview {
    MapView()
}
