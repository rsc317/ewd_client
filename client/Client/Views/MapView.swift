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
    @State private var position = MapCameraPosition.userLocation(followsHeading: true, fallback: .automatic)
    @State private var showCreatePinPointSheet = false
    @State private var screenCoord: CGPoint?
    @State private var reader: MapProxy?
    
    
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
                    self.screenCoord = screenCoord
                    self.reader = reader
                    showCreatePinPointSheet = true
                }
            }
        }
        .sheet(isPresented: $showCreatePinPointSheet) {
            let pinLocation = getLocation(reader: reader, screenCoord: screenCoord)
            CreatePinPointSheetView(location: pinLocation)
                .presentationDragIndicator(.visible)
        }
    }
    
    func getLocation(reader: MapProxy?, screenCoord: CGPoint?) -> CLLocationCoordinate2D? {
        guard let reader = reader else { return nil}
        guard let screenCoord = screenCoord else { return nil}
        return reader.convert(screenCoord, from: .local)
    }
}

#Preview {
    MapView()
}
