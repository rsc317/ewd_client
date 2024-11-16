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
    @State private var selectedMinutes: Int = 0
    @State private var selectedHours: Int = 0
    @State private var imageResponses: [ImageResponse] = []
    
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
                
                PictureGalleryPreview(imageResponses: $imageResponses)
                    .padding()
                PictureGalleryPickerView(imageResponses: $imageResponses)
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
        if let pinLocation = self.pinLocation {
            mapViewModel.addMockPinPoint(pinLocation)
            dismiss()
        }

    }
}

#Preview {
    @Previewable @State var pinLocation: CLLocationCoordinate2D?
    @Previewable @State var mapViewModel: MapViewModel = MapViewModel()

    CreatePinPointSheetView(mapViewModel: $mapViewModel, pinLocation: $pinLocation)
}
