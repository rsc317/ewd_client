//
//  PictureGalleryView.swift
//  client
//
//  Created by Emircan Duman on 16.11.24.
//

import SwiftUI


import SwiftUI

struct PictureGalleryView: View {
    @Binding var imageResponses: [ImageResponse]
    @State private var isSelecting = false
    @State private var selectedImages = Set<UUID>()
    @State private var showDeleteAlert = false

    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 150))]
                    ) {
                        ForEach(imageResponses) { imageResponse in
                            ZStack {
                                Image(uiImage: imageResponse.uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 180, height: 180)
                                    .clipped()
                                    .overlay(
                                        isSelecting && selectedImages.contains(imageResponse.id) ?
                                        Color.black.opacity(0.4) : Color.clear
                                    )

                                if isSelecting {
                                    VStack {
                                        HStack {
                                            Spacer()
                                            Image(systemName: selectedImages.contains(imageResponse.id) ? "checkmark.circle.fill" : "circle")
                                                .foregroundColor(.white)
                                                .imageScale(.large)
                                                .padding(5)
                                        }
                                        Spacer()
                                    }
                                }
                            }
                            .onTapGesture {
                                if isSelecting {
                                    withAnimation {
                                        if selectedImages.contains(imageResponse.id) {
                                            selectedImages.remove(imageResponse.id)
                                        } else {
                                            selectedImages.insert(imageResponse.id)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding()

            VStack {
                Spacer()
                if isSelecting {
                    HStack {
                        Spacer()
                        if !selectedImages.isEmpty {
                            Button(action: {
                                showDeleteAlert = true
                            }) {
                                Image(systemName: "trash")
                                    .imageScale(.large)
                                    .padding()
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .background(.thinMaterial)
                }
            }
        }
        .navigationTitle("Aufgenommene Bilder")
        .toolbarTitleDisplayMode(.inline)
        .navigationBarItems(trailing:
            Button(isSelecting ? "Abbrechen" : "Auswählen") {
                isSelecting.toggle()
                if !isSelecting {
                    selectedImages.removeAll()
                }
            }
        )
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Bilder löschen"),
                message: Text("Möchten Sie die ausgewählten Bilder wirklich löschen?"),
                primaryButton: .destructive(Text("Löschen")) {
                    deleteSelectedImages()
                },
                secondaryButton: .cancel()
            )
        }
    }

    func deleteSelectedImages() {
        withAnimation {
            imageResponses.removeAll { imageResponse in
                selectedImages.contains(imageResponse.id)
            }
            selectedImages.removeAll()
        }
    }
}
struct PictureGalleryPreview: View {
    @Binding var imageResponses: [ImageResponse]
    
    var body: some View {
        NavigationLink(destination: PictureGalleryView(imageResponses: $imageResponses)) {
            ScrollView(.horizontal) {
                LazyHGrid(rows: [GridItem(.adaptive(minimum: 100))]) {
                    ForEach(imageResponses) { imageResponse in
                        Image(uiImage: imageResponse.uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipped()
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    @Previewable @State var imageResponses: [ImageResponse] = [
        ImageResponse(uiImage: UIImage(imageLiteralResourceName: "default")),
        ImageResponse(uiImage: UIImage(imageLiteralResourceName: "default")),
        ImageResponse(uiImage: UIImage(imageLiteralResourceName: "default")),
        ImageResponse(uiImage: UIImage(imageLiteralResourceName: "default")),
        ImageResponse(uiImage: UIImage(imageLiteralResourceName: "default")),
        ImageResponse(uiImage: UIImage(imageLiteralResourceName: "default")),
    ]
    PictureGalleryView(imageResponses: $imageResponses)
}
