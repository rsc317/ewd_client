//
//  PhotoPickerView.swift
//  client
//
//  Created by Emircan Duman on 16.11.24.
//

import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) var dismiss

    @State private var pickerItem: PhotosPickerItem?

    var body: some View {
        PhotosPicker(selection: $pickerItem, matching: .images) {
            Text("Galerie öffnen")
                .font(.headline)
                .foregroundColor(.blue)
        }
        .onChange(of: pickerItem) {
            Task {
                if let pickerItem,
                   let data = try? await pickerItem.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    selectedImage = image
                }
                dismiss()
            }
        }
    }
}

#Preview {
    @Previewable @State var image: UIImage?
    PhotoPickerView(selectedImage: $image)
}
