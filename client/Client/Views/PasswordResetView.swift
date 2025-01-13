//
//  PasswordResetView.swift
//  client
//
//  Created by Emircan Duman on 24.11.24.
//

import SwiftUI

struct PasswordResetView: View {
    @Binding var viewModel: AuthViewModel
    @State var errorMsg: String? = nil
    @State var showPasswortResetConfirmView = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                ViewElementFactory.createTextfield(label: localizationIdentifiers.EMAIL,
                                                   text: $viewModel.email,
                                                   accessibilityId: accessibilityIdentifiers.EMAIL_FIELD)
                ViewElementFactory.createPasswordField(label: localizationIdentifiers.PASSWORD,
                                                       text: $viewModel.password,
                                                       accessibilityId: accessibilityIdentifiers.PASSWORD_FIELD)
                ViewElementFactory.createPasswordField(label: localizationIdentifiers.PASSWORD_REPEAT,
                                                       text: $viewModel.confirmPassword,
                                                       accessibilityId: accessibilityIdentifiers.PASSWORD_REPEAT_FIELD)
                ViewElementFactory.createRegistrationErrorView(errors: viewModel.validationErrors)
                
                if let errorMsg = errorMsg {
                    Text(errorMsg)
                        .foregroundStyle(.error)
                        .font(.footnote)
                }
                
                Button(action: {
                    passwortReset()
                }) {
                    Text(localizationIdentifiers.PASSWORD_FORGET_BTN_TITLE.localized)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.interaction)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .accessibilityIdentifier(accessibilityIdentifiers.PASSWORD_FORGET_BTN)
                .disabled(!viewModel.validationErrors.isEmpty)
                Spacer()
            }
            .navigationTitle(String(localized: localizationIdentifiers.PASSWORD_FORGET_TITLE))
            .modifier(NavigationBarTitleColorModifier(color: .icon))
            .cornerRadius(12)
            .padding(25)
        }
        .sheet(isPresented: $showPasswortResetConfirmView) {
            ConfirmPasswordView(viewModel: $viewModel, onDismiss: {
                self.dismiss()
            })
                .presentationDragIndicator(.visible)
                .presentationDetents([.medium])
        }
    }
    
    func passwortReset() {
        Task {
            do {
                try await viewModel.sendPasswordRequest()
                errorMsg = nil
                showPasswortResetConfirmView = true
            } catch AuthViewModel.PasswordResetError.badCredentials {
                errorMsg = "Email oder Password sind inkorrekt"
            } catch {
                errorMsg = "Unknown Error"
            }
        }
    }
}

#Preview {
    @Previewable @State var viewModel = AuthViewModel()
    PasswordResetView(viewModel: $viewModel)
}
