//
//  CreatePinPointSheetView.swift
//  client
//
//  Created by Emircan Duman on 15.11.24.
//

import SwiftUI
import MapKit
import PhotosUI


struct CreatePinPointSheetView: View {
    @State private var mapViewModel = MapViewModel()
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var selectedMinutes: Int = 0
    @State private var selectedHours: Int = 0
    @State private var showCamera = false
//    @State private var capturedPhotos: [ImageResponse] = []
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var selectedImages: [ImageResponse] = []
    @State var location: CLLocationCoordinate2D?
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing: 20) {
                Text("PinPoint")
                    .font(.largeTitle)
                    .foregroundColor(Color("IconColor"))
                    .padding(.horizontal)
                
                TextField("Titel", text: $title)
                    .font(.title)
                    .padding(8)
                    .background(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                    .padding(.horizontal)
                
                Text("Beschreibung")
                    .font(.headline)
                    .padding(.horizontal)
                    .foregroundColor(Color("IconColor"))
                
                TextEditor(text: $description)
                    .frame(height: 150)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .padding(.horizontal)
                
                HStack {
                    Picker("Stunden", selection: $selectedHours) {
                        ForEach(0..<24) { hour in
                            Text("\(hour)").tag(hour)
                                .foregroundColor(Color("IconColor"))
                            
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 100)
                    Text("h")
                        .font(.headline)
                        .foregroundColor(Color("IconColor"))
                    
                    Picker("Minuten", selection: $selectedMinutes) {
                        ForEach(0..<60) { minute in
                            Text("\(minute)").tag(minute)
                                .foregroundColor(Color("IconColor"))
                            
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 100)
                    Text("min")
                        .font(.headline)
                        .foregroundColor(Color("IconColor"))
                }
                .padding(.horizontal)
                VStack {
                    PictureGalleryPreview(images: $selectedImages)
                    HStack {
                        PhotosPicker(selection: $selectedPhotos, maxSelectionCount: 10, matching: .images) {
                            Image(systemName: "photo")
                                .foregroundColor(Color("IconColor"))
                                .font(.system(size: 32, weight: .bold))
                                .padding()
                        }
                        .onChange(of: selectedPhotos) { oldValue, newValue in
                            Task {
                                selectedImages = []
                                for photo in newValue {
                                    if let data = try? await photo.loadTransferable(type: Data.self),
                                       let image = UIImage(data: data){
                                        selectedImages.append(ImageResponse(uiImage: image))
                                    }
                                }
                            }
                        }
                        Spacer()
                        Button(action: {
                            showCamera = true
                        }) {
                            Image(systemName: "camera")
                                .foregroundColor(Color("IconColor"))
                                .font(.system(size: 32, weight: .bold))
                                .padding()
                        }
                        .fullScreenCover(isPresented: $showCamera) {
                            CameraCaptureView(capturedPhotos: $selectedImages)
                        }
                    }
                }
                .padding()
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: saveData) {
                        Text("Speichern")
                            .font(.headline)
                            .foregroundColor(Color("AccentColor"))
                    }
                }
                
                
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
            .navigationBarTitleDisplayMode(.inline)
            .padding()
        }
    }
    
    private func saveData() {
        dismiss()
        print("Titel: \(title)")
        print("Beschreibung: \(description)")
        print("Dauer: \(selectedHours)h \(selectedMinutes)min")
    }
}

#Preview {
    CreatePinPointSheetView()
}
