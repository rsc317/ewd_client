//
//  LoginView.swift
//  client
//
//  Created by Emircan Duman on 10.11.24.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var errors: [AuthenticationError] = []
    @State private var showAlert: Bool = false
    @State private var showConfirmRegistrationView: Bool = false
    @StateObject private var authManager = AuthenticationManager.shared

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                ViewElementFactory.createTextfield(label: "Benutzername", text: $username)
                ViewElementFactory.createPasswordField(label: "Passwort", text: $password)
                HStack {
                    Toggle(isOn: $authManager.stayLoggedIn) {
                        Text("Angemeldet bleiben?")
                            .font(.subheadline)
                            .foregroundColor(.interaction)
                    }
                    .toggleStyle(.switch)
                    .tint(Color.interaction)
                }
                .padding(.horizontal)
                ViewElementFactory.createInteractionButton(label: "Anmelden", action: login)
                ViewElementFactory.createInteractionFooter(
                    footerText: "Noch keinen Account?",
                    footerButtonText: "Registrieren!",
                    view: RegistrationView()
                )
                
                Spacer()
            }
            .navigationTitle("Login")
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
    
    private func login() {
        if username.isEmpty || password.isEmpty {
            showAlert = true
        } else if errors.contains(.userNotVerifiedError) {
            showConfirmRegistrationView = true
            showAlert = true
        } else {
            AuthenticationManager.shared.logIn(username: username, password: password)
            showAlert = false
        }
    }
}

#Preview {
    LoginView()
}
