//
//  DetailPinPointInfoView.swift
//  client
//
//  Created by Emircan Duman on 04.01.25.
//

import SwiftUI

struct DetailPinPointInfoView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var viewModel: DetailPintPointViewModel
    let onDismiss: () -> Void

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                VStack() {
                    Text(viewModel.pinPoint.description)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .cornerRadius(10)
                }
                .padding()
                
                Divider()
                
                if let address = viewModel.getAddress() {
                    HStack {
                        Image(systemName: "globe.europe.africa.fill")
                            .foregroundStyle(.icon)
                            .font(.system(size: 60))
                        VStack(alignment: .leading) {
                            Text("\(address.streetName) \(address.streetNumber)")
                                .font(.headline)
                            Text("\(address.postcode), \(address.city)")
                                .font(.subheadline)
                            Text("\(address.country)")
                                .font(.subheadline)
                        }
                        .padding()
                    }
                }

                Divider()

                PictureGalleryPreview(imageResponses: $viewModel.pinPointImages)
                    .padding()
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.vertical, 20)
            .padding(.horizontal)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    VStack{
                        Button(action: {
                            onDismiss()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 18, weight: .light))
                                .foregroundColor(.accentColor)
                        }
                    }
                }
            }
        }
        .onAppear {
            fetchImages()
        }
    }
    
    func fetchImages() {
        Task {
            do {
                try await viewModel.fetchImages()
            } catch {}
        }
    }
}

#Preview {
    @Previewable @State var viewModel = DetailPintPointViewModel(pinPoint: PinPoint(title: "String", description: "String", duration: Duration(hours: 30, minutes: 30), coordinate: GeoCoordinate(latitude: 0, longitude: 0)))
    DetailPinPointInfoView(viewModel: $viewModel, onDismiss: {})
}
