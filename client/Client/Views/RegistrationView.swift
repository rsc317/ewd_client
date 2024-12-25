//
//  RegistrationView.swift
//  client
//
//  Created by Emircan Duman on 24.11.24.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showConfirmRegistrationView: Bool = false
    @State private var errors: [AuthenticationError] = []
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                ViewElementFactory.createTextfield(label: "E-Mail", text: $email, accessibilityIdentifier: accessibility_EMAIL_FIELD)
                ViewElementFactory.createTextfield(label: "Benutzername", text: $username, accessibilityIdentifier: accessibility_USERNAME_FIELD)
                ViewElementFactory.createPasswordField(label: "Passwort", text: $password, accessibilityIdentifier: accessibility_PASSWORD_FIELD)
                ViewElementFactory.createPasswordField(label: "Passwort bestätigen", text: $confirmPassword, accessibilityIdentifier: accessibility_PASSWORD_REPEAT_FIELD)
                ViewElementFactory.createRegistrationErrorView(errors: errors)
                ViewElementFactory.createInteractionButton(label: "Registrieren", action: signUp, accessibilityIdentifier: accessibility_SIGNUP_BTN)
                Spacer()
            }
            .navigationTitle("Registrieren")
            .modifier(NavigationBarTitleColorModifier(color: .icon))
            .cornerRadius(12)
            .padding(25)
        }
        .sheet(isPresented: $showConfirmRegistrationView) {
            ConfirmRegistrationView()
                .presentationDragIndicator(.visible)
                .presentationDetents([.medium])
        }
    }
    
    private func signUp() {
        errors = AuthenticationManager.shared.signUp(email: email, username: username, password: password, passwordConfirm: confirmPassword)
        showConfirmRegistrationView = errors.isEmpty
    }
}

#Preview {
    RegistrationView()
}
