//
//  StringExtension.swift
//  client
//
//  Created by Emircan Duman on 06.11.24.
//

import Foundation

extension String {
    var isNumeric: Bool {
        return !self.isEmpty && self.allSatisfy { $0.isNumber }
    }
    
    var nonEmpty: String? {
        isEmpty ? nil : self
    }
}

extension String.LocalizationValue {
    var localized: String {
        return String(localized: self)
    }
}
