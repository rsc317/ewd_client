//
//  localizationIdentifiers.swift
//  client
//
//  Created by Johannes Grothe on 25.12.24.
//

import Foundation

struct localizationIdentifiers {
    // Generic
    static let SIGNUP: String.LocalizationValue = "SIGNUP"
    static let LOGIN: String.LocalizationValue = "LOGIN"
    
    static let USERNAME: String.LocalizationValue = "USERNAME"
    static let PASSWORD: String.LocalizationValue = "PASSWORD"
    
    // Login View
    static let LOGIN_TITLE: String.LocalizationValue = "LOGIN_TITLE"
    static let STAY_LOGGED_IN: String.LocalizationValue = "STAY_LOGGED_IN"
    static let NOT_SIGNED_UP_YET: String.LocalizationValue = "NOT_SIGNED_UP_YET"
    static let WRONG_CREDENTIALS: String.LocalizationValue = "WRONG_CREDENTIALS"
    
    // Confirm Registration View
    static let CODE_WAS_SENT: String.LocalizationValue = "CODE_WAS_SENT"
    static let WRONG_CODE: String.LocalizationValue = "WRONG_CODE"
    static let CODE_NOT_SENT: String.LocalizationValue = "CODE_NOT_SENT"
    
    // Signup View
    static let SIGNUP_TITLE: String.LocalizationValue = "SIGNUP_TITLE"
    static let EMAIL: String.LocalizationValue = "EMAIL"
    static let PASSWORD_REPEAT: String.LocalizationValue = "PASSWORD_REPEAT"
    
    static let ILLEGAL_MAIL: String.LocalizationValue = "ILLEGAL_MAIL"
    static let PASSWORDS_DONT_MATCH: String.LocalizationValue = "PASSWORDS_DONT_MATCH"
    static let USERNAME_TOO_SHORT: String.LocalizationValue = "USERNAME_TOO_SHORT"
    static let PASSWORD_TOO_SHORT: String.LocalizationValue = "PASSWORD_TOO_SHORT"
    static let PASSWORD_NO_SPECIAL_CHARACTER: String.LocalizationValue = "PASSWORD_NO_SPECIAL_CHARACTER"
    static let PASSWORD_NO_CAPITAL_CHARACTER: String.LocalizationValue = "PASSWORD_NO_CAPITAL_CHARACTER"
    static let PASSWORD_HAS_INVALID_CHARACTER: String.LocalizationValue = "PASSWORD_HAS_INVALID_CHARACTER"
    // PasswordForgot View
    static let PASSWORD_FORGET_BTN_TITLE: String.LocalizationValue = "PASSWORD_FORGOT_BTN_TITLE"
    static let PASSWORD_FORGET_TITLE: String.LocalizationValue = "PASSWORD_FORGET_TITLE"
    static let PASSWORD_FORGET_TEXT: String.LocalizationValue = "PASSWORD_FORGET_TEXT"
    static let PASSWORD_FORGET: String.LocalizationValue = "PASSWORD_FORGET"
}
