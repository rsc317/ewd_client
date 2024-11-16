//
//  LocationImage.swift
//  client
//
//  Created by Emircan Duman on 06.11.24.
//

import Foundation
import SwiftUI

struct ImageResponse: Codable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    let id = UUID()
    let uiImage: UIImage
    
    init(uiImage: UIImage) {
        self.uiImage = uiImage
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let imageDataString = try container.decode(String.self, forKey: .data)
        if let imageData = Data(base64Encoded: imageDataString),
           let uiImage = UIImage(data: imageData) {
            self.uiImage = uiImage
        } else {
            if let defaultImage = UIImage(named: "default") {
                self.uiImage = defaultImage
                print("Fehler: Konnte Bilddaten nicht dekodieren. Verwende Standardbild.")
            } else {
                throw DecodingError.dataCorruptedError(forKey: .data, in: container, debugDescription: "Konnte weder Bilddaten dekodieren noch Standardbild laden.")
            }
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let imageData = self.uiImage.jpegData(compressionQuality: 1.0) {
            let imageDataString = imageData.base64EncodedString()
            try container.encode(imageDataString, forKey: .data)
        } else {
            // Versuch, das Standardbild zu kodieren
            if let defaultImage = UIImage(named: "default"),
               let defaultImageData = defaultImage.jpegData(compressionQuality: 1.0) {
                let defaultImageDataString = defaultImageData.base64EncodedString()
                try container.encode(defaultImageDataString, forKey: .data)
                print("Hinweis: Verwende Standardbild beim Kodieren.")
            } else {
                throw EncodingError.invalidValue(self.uiImage, EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "Konnte Bilddaten nicht encodieren."))
            }
        }
    }
}
