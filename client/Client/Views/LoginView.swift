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
    @State private var locationManager = LocationManager.shared
    @State private var error: AuthenticationError? = nil
    @State private var showAlert: Bool = false
    @State private var showConfirmRegistrationView: Bool = false
    @StateObject private var authManager = AuthenticationManager.shared

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                ViewElementFactory.createTextfield(label: localizationIdentifiers.USERNAME,
                                                   text: $username,
                                                   accessibilityId: accessibilityIdentifiers.USERNAME_FIELD)
                ViewElementFactory.createPasswordField(label: localizationIdentifiers.PASSWORD,
                                                       text: $password,
                                                       accessibilityId: accessibilityIdentifiers.PASSWORD_FIELD)
                HStack {
                    Toggle(isOn: $authManager.stayLoggedIn) {
                        Text(localizationIdentifiers.STAY_LOGGED_IN.localized)
                            .font(.subheadline)
                            .foregroundColor(.interaction)
                    }
                    .toggleStyle(.switch)
                    .tint(Color.interaction)
                }
                .padding(.horizontal)
                if self.error == .credentialsError {
                    Text(localizationIdentifiers.WRONG_CREDENTIALS.localized)
                        .font(.footnote)
                }
                ViewElementFactory.createInteractionButton(label: localizationIdentifiers.LOGIN,
                                                           action: login,
                                                           accessibilityId: accessibilityIdentifiers.LOGIN_BTN)
                ViewElementFactory.createInteractionFooter(
                    footerText: localizationIdentifiers.NOT_SIGNED_UP_YET,
                    footerButtonText: localizationIdentifiers.SIGNUP,
                    view: RegistrationView(),
                    accessibilityId: accessibilityIdentifiers.SIGNUP_BTN
                )
                
                Spacer()
            }
            .navigationTitle(localizationIdentifiers.LOGIN_TITLE.localized)
            .modifier(NavigationBarTitleColorModifier(color: .icon))
            .cornerRadius(12)
            .padding(25)
        }
        .sheet(isPresented: $showConfirmRegistrationView) {
            ConfirmRegistrationView()
                .presentationDragIndicator(.visible)
                .presentationDetents([.medium])
        }
        .onAppear() {
            locationManager.requestLocation()
        }
    }
    
    private func login() {
        if !username.isEmpty && !password.isEmpty {
            Task {
                self.error = await AuthenticationManager.shared.logIn(username: username, password: password)
                DispatchQueue.main.async {
                    self.showConfirmRegistrationView = (self.error == .userNotVerifiedError)
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
