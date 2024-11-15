//
//  ColorExtension.swift
//  client
//
//  Created by Emircan Duman on 15.11.24.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let red, green, blue, alpha: Double
        switch hex.count {
        case 6:
            red = Double((int >> 16) & 0xFF) / 255
            green = Double((int >> 8) & 0xFF) / 255
            blue = Double(int & 0xFF) / 255
            alpha = 1.0
        case 8:
            alpha = Double((int >> 24) & 0xFF) / 255
            red = Double((int >> 16) & 0xFF) / 255
            green = Double((int >> 8) & 0xFF) / 255
            blue = Double(int & 0xFF) / 255
        default:
            red = 1.0
            green = 1.0
            blue = 1.0
            alpha = 1.0
        }
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}
