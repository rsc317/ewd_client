//
//  ViewElementFactory.swift
//  client
//
//  Created by Emircan Duman on 24.11.24.
//

import SwiftUI

class ViewElementFactory {
    static func createInteractionButton(label: String, action: @escaping () -> Void, accessibilityIdentifier: String) -> some View {
        Button(action: {
            action()
        }) {
            Text(label)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(Color.interaction)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
        .accessibilityIdentifier(accessibilityIdentifier)
    }
    
    static func createTextfield(label: String, text: Binding<String>, accessibilityIdentifier: String) -> some View {
        TextField(label, text: text)
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.accent, lineWidth: 1)
            )
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .accessibilityIdentifier(accessibilityIdentifier)
    }
    
    static func createPasswordField(label: String, text: Binding<String>, accessibilityIdentifier: String) -> some View {
        SecureField(label, text: text)
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.accent, lineWidth: 1)
            )
            .accessibilityIdentifier(accessibilityIdentifier)
    }
    
    static func createInteractionFooter(footerText: String, footerButtonText: String, view: some View, accessibilityIdentifier: String) -> some View {
        VStack(spacing: 8) {
            HStack {
                Text(footerText)
                    .font(.footnote)
                NavigationLink {
                    view
                } label: {
                    Text(footerButtonText)
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundColor(.interaction)
                }
                .accessibilityIdentifier(accessibilityIdentifier)
            }
        }
    }
    
    static func createInteractionFooter(footerText: String, footerButtonText: String, action: @escaping () -> Void) -> some View {
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
            }
        }
    }
    
    static func createRegistrationErrorView(errors: [AuthenticationError]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(errors, id:\.self) { showError in
                switch showError {
                case .usernameAlreadyInUse:
                    errorText("Benutzername wird bereits verwendet!")
                case .usernameToShort:
                    errorText("Benutzername muss mindestens 4 Zeichen lang sein!")
                case .passwordToShort:
                    errorText("Password muss mindestens 8 Zeichen lang sein!")
                case .passwordNoSpecialCharacter:
                    errorText("Password muss mindestens ein Sonderzeichen: @#$%^&*()-_=+{}|:,.<>? enthalten!")
                case .passwordNoCapitalCharacter:
                    errorText("Password muss mindestens ein Großbuchstabe enthalten!")
                case .passwordHasInvalidCharacter:
                    errorText("Password darf kein Specialzeichen: <>'\"\\/; enthalten!")
                case .passwordNotMatch:
                    errorText("Passwörter stimmen nicht überein!")
                case .emailAlreadyInUse:
                    errorText("E-Mail wird bereits verwendet!")
                case .emailInvalid:
                    errorText("Keine gültige E-Mail Addresse!")
                default:
                    EmptyView()
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
