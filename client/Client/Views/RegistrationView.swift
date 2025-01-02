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
                ViewElementFactory.createTextfield(label: localizationIdentifiers.EMAIL,
                                                   text: $email,
                                                   accessibilityId: accessibilityIdentifiers.EMAIL_FIELD)
                ViewElementFactory.createTextfield(label: localizationIdentifiers.USERNAME,
                                                   text: $username,
                                                   accessibilityId: accessibilityIdentifiers.USERNAME_FIELD)
                ViewElementFactory.createPasswordField(label: localizationIdentifiers.PASSWORD,
                                                       text: $password,
                                                       accessibilityId: accessibilityIdentifiers.PASSWORD_FIELD)
                ViewElementFactory.createPasswordField(label: localizationIdentifiers.PASSWORD_REPEAT,
                                                       text: $confirmPassword,
                                                       accessibilityId: accessibilityIdentifiers.PASSWORD_REPEAT_FIELD)
                ViewElementFactory.createRegistrationErrorView(errors: errors)
                ViewElementFactory.createInteractionButton(label: localizationIdentifiers.SIGNUP,
                                                           action: signUp,
                                                           accessibilityId: accessibilityIdentifiers.LOGIN_BTN)
                Spacer()
            }
            .navigationTitle(String(localized: localizationIdentifiers.SIGNUP_TITLE))
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
