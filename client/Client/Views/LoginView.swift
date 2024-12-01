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
    @State private var error: [AuthenticationError] = []
    @State private var showError: Bool = false
    @State private var showConfirmRegistrationView: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                ViewElementFactory.createTextfield(label: "Benutzername", text: $username)
                ViewElementFactory.createPasswordField(label: "Passwort", text: $password)
                ViewElementFactory.createInteractionButton(label: "Anmelden", action: login)
                ViewElementFactory.createInteractionFooter(
                    footerText: "Noch keinen Account?",
                    footerButtonText: "Registrieren!",
                    view: RegistrationView()
                )
                
                HStack {
                    Text("Bereits registriert?")
                        .font(.footnote)
                    Button {
                        showConfirmRegistrationView = true
                    } label: {
                        Text("Bestätige deinen Account!")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .foregroundColor(.interaction)
                    }
                }
                
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
            showError = true
        } else {
            AuthenticationManager.shared.logIn(username: username, password: password)
            showError = false
        }
    }
}

#Preview {
    LoginView()
}
