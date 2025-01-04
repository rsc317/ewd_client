//
//  RegistrationView.swift
//  client
//
//  Created by Emircan Duman on 24.11.24.
//

import SwiftUI

struct RegistrationView: View {
    @Binding var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                ViewElementFactory.createTextfield(label: localizationIdentifiers.EMAIL,
                                                   text: $viewModel.email,
                                                   accessibilityId: accessibilityIdentifiers.EMAIL_FIELD)
                
                ViewElementFactory.createTextfield(label: localizationIdentifiers.USERNAME,
                                                   text: $viewModel.username,
                                                   accessibilityId: accessibilityIdentifiers.USERNAME_FIELD)
                
                ViewElementFactory.createPasswordField(label: localizationIdentifiers.PASSWORD,
                                                       text: $viewModel.password,
                                                       accessibilityId: accessibilityIdentifiers.PASSWORD_FIELD)
                
                ViewElementFactory.createPasswordField(label: localizationIdentifiers.PASSWORD_REPEAT,
                                                       text: $viewModel.confirmPassword,
                                                       accessibilityId: accessibilityIdentifiers.PASSWORD_REPEAT_FIELD)
                
                ViewElementFactory.createRegistrationErrorView(errors: viewModel.validationErrors)
                
                ViewElementFactory.createInteractionButton(label: localizationIdentifiers.SIGNUP,
                                                           action: viewModel.registrate,
                                                           accessibilityId: accessibilityIdentifiers.SIGNUP_BTN)
                Spacer()
            }
            .navigationTitle(String(localized: localizationIdentifiers.SIGNUP_TITLE))
            .modifier(NavigationBarTitleColorModifier(color: .icon))
            .cornerRadius(12)
            .padding(25)
        }
        .sheet(isPresented: $viewModel.showConfirmRegistrationView) {
            ConfirmRegistrationView(viewModel: $viewModel)
                .presentationDragIndicator(.visible)
                .presentationDetents([.medium])
        }
    }
}

#Preview {
    @Previewable @State var viewModel = AuthViewModel()
    RegistrationView(viewModel: $viewModel)
}
