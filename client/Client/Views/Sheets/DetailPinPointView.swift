//
//  DetailPinPointView.swift
//  client
//
//  Created by Emircan Duman on 01.12.24.
//

import SwiftUI

struct DetailPinPointView: View {
    @State private var imageResponses: [ImageResponse] = []
    @Environment(\.dismiss) var dismiss
    var pinPoint: PinPoint
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(pinPoint.title)
                        .font(.largeTitle)
                        .foregroundColor(Color("IconColor"))
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading) {
                        Text(pinPoint.description)
                               .font(.body)
                               .multilineTextAlignment(.leading)
                               .padding()
                               .frame(maxWidth: .infinity, minHeight: 420, alignment: .topLeading)
                               .cornerRadius(10)
                       }
                       .padding()
                    
                    PictureGalleryPreview(imageResponses: $imageResponses)
                        .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.vertical, 20)
                .padding(.horizontal)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(Color("AccentColor"))
                    }
                }
            }

        }
        .onAppear(perform: {
            self.imageResponses = [
                ImageResponse(uiImage: UIImage(imageLiteralResourceName: "default")),
                ImageResponse(uiImage: UIImage(imageLiteralResourceName: "default")),
                ImageResponse(uiImage: UIImage(imageLiteralResourceName: "default")),
                ImageResponse(uiImage: UIImage(imageLiteralResourceName: "default")),
                ImageResponse(uiImage: UIImage(imageLiteralResourceName: "default")),
                ImageResponse(uiImage: UIImage(imageLiteralResourceName: "default")),
            ]
        })
    }
}

#Preview {
    let pinPoint = PinPoint(title: "String", description: "String", duration: Duration(hours: 30, minutes: 30), coordinate: GeoCoordinate(latitude: 0, longitude: 0))
    DetailPinPointView(pinPoint: pinPoint)
}
