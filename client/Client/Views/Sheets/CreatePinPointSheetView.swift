//
//  CreatePinPointSheetView.swift
//  client
//
//  Created by Emircan Duman on 15.11.24.
//

import SwiftUI
import MapKit


struct CreatePinPointSheetView: View {
    @Binding var mapViewModel: MapViewModel
    @Binding var pinLocation: CLLocationCoordinate2D?
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var selectedMinutes: Double = 0
    @State private var selectedHours: Double = 0
    @State private var imageResponses: [ImageResponse] = []
    
    @FocusState private var isFocused: Bool

    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Spacer()
                    Text("PinPoint")
                        .font(.largeTitle)
                        .foregroundColor(Color("IconColor"))
                        .padding(.horizontal)
                    
                    TextField("Titel", text: $title)
                        .focused($isFocused)
                        .font(.title)
                        .padding(8)
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .padding(.horizontal)
                    Spacer()
                    Text("Beschreibung")
                        .font(.headline)
                        .padding(.horizontal)
                        .foregroundColor(Color("IconColor"))
                    
                    TextEditor(text: $description)
                        .focused($isFocused)
                        .frame(height: 120)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .padding(.horizontal)
                    Spacer()
                    PictureGalleryPreview(imageResponses: $imageResponses, selectable: true)
                        .padding()
                    Spacer()
                    PictureGalleryPickerView(imageResponses: $imageResponses)
                        .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.vertical, 20)
                .padding(.horizontal)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Fertig") {
                            isFocused = false
                        }
                    }
                }

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
        }
    }
    
    private func saveData() {
        Task {
            do {
                try await mapViewModel.createPinPoint(locationCoordinates: pinLocation, title: title, description: description, minutes: selectedMinutes, hours: selectedHours, imagesResponses: imageResponses)
            } catch {
                print("Fehler beim Laden der Daten: \(error)")
            }
        }
        dismiss()
    }
}

#Preview {
    @Previewable @State var pinLocation: CLLocationCoordinate2D?
    @Previewable @State var mapViewModel: MapViewModel = MapViewModel()

    CreatePinPointSheetView(mapViewModel: $mapViewModel, pinLocation: $pinLocation)
}
