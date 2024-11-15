//
//  AddPinPointSheetView.swift
//  client
//
//  Created by Emircan Duman on 15.11.24.
//

import SwiftUI
import MapKit


struct AddPinPointSheetView: View {
    @State private var mapViewModel = MapViewModel()
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var selectedMinutes: Int = 0
    @State private var selectedHours: Int = 0
    @State private var selectedImage: UIImage? = nil
    @State private var showCamera = false
    @State private var showGalleryPicker = false
    @State var location: CLLocationCoordinate2D?
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
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
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 5)
                    } else {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.3))
                            .overlay(
                                Text("Kein Bild ausgewählt")
                                    .foregroundColor(.gray)
                            )
                            .frame(height: 150)
                    }
                    Spacer()
                    Button(action: {
                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            showCamera = true
                        } else {
                            showGalleryPicker = true
                        }
                    }) {
                        HStack {
                            Image(systemName: "camera")
                                .font(.headline)
                            Text("Foto schießen")
                                .font(.headline)
                        }
                        .padding()
                        .foregroundColor(Color.white)
                        .background(Color("IconColor"))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: saveData) {
                        Text("Speichern")
                            .font(.headline)
                            .foregroundColor(Color("IconColor"))
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(Color("IconColor"))
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showGalleryPicker) {
            PhotoPickerView(selectedImage: $selectedImage)
        }
        .fullScreenCover(isPresented: $showCamera) {
            CameraView(selectedImage: $selectedImage)
        }
    }
    
    private func saveData() {
        dismiss()
        print("Titel: \(title)")
        print("Beschreibung: \(description)")
        print("Dauer: \(selectedHours)h \(selectedMinutes)min")
        if let image = selectedImage {
            print("Bild wurde ausgewählt")
        } else {
            print("Kein Bild ausgewählt")
        }
    }
}

#Preview {
    AddPinPointSheetView()
}
