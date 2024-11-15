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
    }
    
    func handleTapGesture(screenCoord: CGPoint, reader: MapProxy) {
        if let pinLocation = reader.convert(screenCoord, from: .local) {
            print(pinLocation)
            mapViewModel.addMockPinPoint(pinLocation)
        }
    }
}

#Preview {
    MapView()
}
