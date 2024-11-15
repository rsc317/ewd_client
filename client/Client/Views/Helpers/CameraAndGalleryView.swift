//
//  CameraAndGalleryView.swift
//  client
//
//  Created by Emircan Duman on 16.11.24.
//

import SwiftUI
import PhotosUI

struct CameraAndGalleryView: View {
    @State private var selectedImage: UIImage? = nil
    @State private var showCamera = false
    @State private var showPhotoPicker = false

    var body: some View {
        VStack {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 5)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 300)
                    .overlay(
                        Text("Kein Bild ausgewählt")
                            .foregroundColor(.gray)
                    )
            }

            // Button, um Foto oder Galerie zu öffnen
            Button(action: {
                showPhotoPicker = true
            }) {
                Text("Foto aufnehmen oder auswählen")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
        .sheet(isPresented: $showPhotoPicker) {
            PhotoPickerView(selectedImage: $selectedImage)
        }
        .fullScreenCover(isPresented: $showCamera) {
            CameraView(selectedImage: $selectedImage)
        }
    }
}

#Preview {
    CameraAndGalleryView()
}
