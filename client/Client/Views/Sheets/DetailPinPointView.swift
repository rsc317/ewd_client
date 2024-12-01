//
//  DetailPinPointView.swift
//  client
//
//  Created by Emircan Duman on 01.12.24.
//

import SwiftUI

struct DetailPinPointView: View {
    var pinPoint: PinPoint

    var body: some View {
        VStack {
            Text(pinPoint.title)
                .font(.title)
            Text(pinPoint.description ?? "Keine Beschreibung")
                .font(.body)
                .padding()
            Spacer()
        }
        .padding()
    }
}

#Preview {
    let pinPoint = PinPoint(title: "String", description: "String", duration: Duration(hours: 30, minutes: 30), coordinate: GeoCoordinate(latitude: 0, longitude: 0))
    DetailPinPointView(pinPoint: pinPoint)
}
