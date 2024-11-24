//
//  ViewElementFactory.swift
//  client
//
//  Created by Emircan Duman on 24.11.24.
//

import SwiftUI

class ViewElementFactory {
    static func createInteractionButton(label: String, action: @escaping () -> Void) -> some View {
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
    }
    
    static func createTextfield(label: String, text: Binding<String>) -> some View {
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
    }
    
    static func createPasswordField(label: String, text: Binding<String>) -> some View {
        SecureField(label, text: text)
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.accent, lineWidth: 1)
            )
    }
    
    static func createInteractionFooter(footerText: String, footerButtonText: String, view: some View) -> some View {
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
            }
        }
    }
    
    static func createRegistrationErrorView(errors: [AuthenticationError]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(errors, id:\.self) { showError in
                switch showError {
                case .usernameAlreadyInUse:
                    Text("Benutzername wird bereits verwendet!")
                        .foregroundColor(.red)
                        .font(.footnote)
                case .usernameToShort:
                    Text("Benutzername muss mindestens 4 Zeichen lang sein!")
                        .foregroundColor(.red)
                        .font(.footnote)
                case .passwordToShort:
                    Text("Password muss mindestens 8 Zeichen lang sein!")
                        .foregroundColor(.red)
                        .font(.footnote)
                case .passwordNoSpecialCharacter:
                    Text("Password muss mindestens ein Sonderzeichen: @#$%^&*()-_=+{}|:,.<>? enthalten!")
                        .foregroundColor(.red)
                        .font(.footnote)
                case .passwordNoCapitalCharacter:
                    Text("Password muss mindestens ein Großbuchstabe enthalten!")
                        .foregroundColor(.red)
                        .font(.footnote)
                case .passwordHasInvalidCharacter:
                    Text("Password darf kein Specialzeichen: <>'\"\\/; enthalten!")
                        .foregroundColor(.red)
                        .font(.footnote)
                case .passwordNotMatch:
                    Text("Passwörter stimmen nicht überein!")
                        .foregroundColor(.red)
                        .font(.footnote)
                case .emailAlreadyInUse:
                    Text("E-Mail wird bereits verwendet!")
                        .foregroundColor(.red)
                        .font(.footnote)
                case .emailInvalid:
                    Text("Keine gültige E-Mail Addresse!")
                        .foregroundColor(.red)
                        .font(.footnote)
                default:
                    EmptyView()
                }
            }
        }
    }
}
