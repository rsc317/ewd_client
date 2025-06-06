//
//  LoginView.swift
//  client
//
//  Created by Emircan Duman on 10.11.24.
//

import SwiftUI

struct LoginView: View {
    @State private var showAlert: Bool = false
    @State private var viewModel = AuthViewModel()
    @StateObject private var authManager = AuthenticationManager.shared
    @State private var locationManager = LocationManager.shared
    @State var errorMsg: String? = nil

    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                ViewElementFactory.createTextfield(label: localizationIdentifiers.USERNAME,
                                                   text: $viewModel.username,
                                                   accessibilityId: accessibilityIdentifiers.USERNAME_FIELD)
                ViewElementFactory.createPasswordField(label: localizationIdentifiers.PASSWORD,
                                                       text: $viewModel.password,
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
                
                if let errorMsg = errorMsg {
                    Text(errorMsg)
                        .foregroundStyle(.error)
                        .font(.footnote)
                }
                
                ViewElementFactory.createInteractionButton(label: localizationIdentifiers.LOGIN,
                                                           action: login,
                                                           accessibilityId: accessibilityIdentifiers.LOGIN_BTN)
                
                ViewElementFactory.createInteractionFooter(
                    footerText: localizationIdentifiers.PASSWORD_FORGET_TEXT,
                    footerButtonText: localizationIdentifiers.PASSWORD_FORGET,
                    view: PasswordResetView(viewModel: $viewModel),
                    accessibilityId: accessibilityIdentifiers.PASSWORD_FORGET_BTN
                )
                
                ViewElementFactory.createInteractionFooter(
                    footerText: localizationIdentifiers.NOT_SIGNED_UP_YET,
                    footerButtonText: localizationIdentifiers.SIGNUP,
                    view: RegistrationView(viewModel: $viewModel),
                    accessibilityId: accessibilityIdentifiers.SIGNUP_BTN
                )
                
                Spacer()
            }
            .navigationTitle(localizationIdentifiers.LOGIN_TITLE.localized)
            .modifier(NavigationBarTitleColorModifier(color: .icon))
            .cornerRadius(12)
            .padding(25)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $viewModel.showConfirmRegistrationView) {
            ConfirmRegistrationView(viewModel: $viewModel)
                .presentationDragIndicator(.visible)
                .presentationDetents([.medium])
        }
        .onAppear() {
            locationManager.requestLocation()
        }
    }
    
    func login() {
        Task {
            do {
                try await viewModel.login()
                errorMsg = nil
            } catch AuthViewModel.LoginError.badCredentials {
                errorMsg = localizationIdentifiers.WRONG_CREDENTIALS.localized
            } catch {
                errorMsg = "Unknown Error"
            }
        }
    }
}

#Preview {
    LoginView()
}
