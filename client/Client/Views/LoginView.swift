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
                ViewElementFactory.createInteractionButton(label: localizationIdentifiers.LOGIN,
                                                           action: viewModel.login,
                                                           accessibilityId: accessibilityIdentifiers.LOGIN_BTN)
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
}

#Preview {
    LoginView()
}
