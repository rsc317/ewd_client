//
//  ViewElementFactory.swift
//  client
//
//  Created by Emircan Duman on 24.11.24.
//

import SwiftUI

class ViewElementFactory {
    static func createInteractionButton(label: String.LocalizationValue, action: @escaping () -> Void, accessibilityId: String) -> some View {
        Button(action: {
            action()
        }) {
            Text(label.localized)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(Color.interaction)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
        .accessibilityIdentifier(accessibilityId)
    }
    
    static func createTextfield(label: String.LocalizationValue, text: Binding<String>, accessibilityId: String) -> some View {
        TextField(label.localized, text: text)
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.accent, lineWidth: 1)
            )
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .accessibilityIdentifier(accessibilityId)
    }
    
    static func createPasswordField(label: String.LocalizationValue, text: Binding<String>, accessibilityId: String) -> some View {
        SecureField(label.localized, text: text)
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(12)
            .textContentType(.oneTimeCode)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.accent, lineWidth: 1)
            )
            .accessibilityIdentifier(accessibilityId)
    }
    
    static func createInteractionFooter(footerText: String.LocalizationValue, footerButtonText: String.LocalizationValue, view: some View, accessibilityId: String) -> some View {
        VStack(spacing: 8) {
            HStack {
                Text(footerText.localized)
                    .font(.footnote)
                NavigationLink {
                    view
                } label: {
                    Text(footerButtonText.localized)
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundColor(.interaction)
                }
                .accessibilityIdentifier(accessibilityId)
            }
        }
    }
    
    static func createInteractionFooter(footerText: String, footerButtonText: String, action: @escaping () -> Void, accessibilityId: String) -> some View {
        VStack(spacing: 8) {
            HStack {
                Text(footerText)
                    .font(.footnote)
                Button {
                    action()
                } label: {
                    Text(footerButtonText)
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundColor(.interaction)
                }
                .accessibilityIdentifier(accessibilityId)
            }
        }
    }

    static func createRegistrationErrorView(errors: [AuthViewModel.ValidationError]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(errors, id: \.self) { showError in
                switch showError {
                case .usernameToShort:
                    errorText(localizationIdentifiers.USERNAME_TOO_SHORT.localized)
                case .passwordToShort:
                    errorText(localizationIdentifiers.PASSWORD_TOO_SHORT.localized)
                case .passwordNoSpecialCharacter:
                    errorText(localizationIdentifiers.PASSWORD_NO_SPECIAL_CHARACTER.localized)
                case .passwordNoCapitalCharacter:
                    errorText(localizationIdentifiers.PASSWORD_NO_CAPITAL_CHARACTER.localized)
                case .passwordHasInvalidCharacter:
                    errorText(localizationIdentifiers.PASSWORD_HAS_INVALID_CHARACTER.localized)
                case .passwordNotMatch:
                    errorText(localizationIdentifiers.PASSWORDS_DONT_MATCH.localized)
                case .emailInvalid:
                    errorText(localizationIdentifiers.ILLEGAL_MAIL.localized)
                }
            }
        }
    }
    
    static func errorText(_ text: String) -> some View {
        Text(text)
            .foregroundColor(Color.error)
            .font(.footnote)
    }
    
    static func succesText(_ text: String) -> some View {
        Text(text)
            .foregroundColor(Color.success)
            .font(.footnote)
    }
}
