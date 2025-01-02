//
//  ConfirmRegistrationView.swift
//  client
//
//  Created by Emircan Duman on 24.11.24.
//

import SwiftUI

struct ConfirmRegistrationView: View {
    @Binding var viewModel: AuthViewModel
    
    @State var code: String = ""
    @State var showVerificationSend: Bool = false
    @State var showError: Bool = false
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Image(systemName: "envelope.fill")
                    .foregroundStyle(.icon)
                    .font(.system(size: 100))
                Text("Verifizierungs Code")
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundStyle(.icon)
                ViewElementFactory.createTextfield(label: "Code",
                                                   text: $code,
                                                   accessibilityId: accessibilityIdentifiers.VERIFICATION_TOKEN_FIELD)
                .padding(.horizontal, 10)
                
                ViewElementFactory.createInteractionFooter(
                    footerText: "Bitte überprüfen Sie ihre Emails!",
                    footerButtonText: "Nochmal senden?",
                    action: getVerificationCode,
                    accessibilityId: accessibilityIdentifiers.SEND_VERIFICATION_CODE_BUTTON
                )
                
                if showVerificationSend {
                    Text(localizationIdentifiers.CODE_WAS_SENT.localized)
                        .foregroundStyle(.success)
                        .font(.footnote)
                }
                
                if showError {
                    Text("Ein Fehler ist aufgetreten!")
                        .foregroundStyle(.error)
                        .font(.footnote)
                }
                
                ViewElementFactory.createInteractionButton(label: "Verifizieren", action: postVerificationCode,
                                                           accessibilityId: accessibilityIdentifiers.VERIFICATION_BUTTON)
                
                .padding(.horizontal, 10)
            }
            .cornerRadius(12)
            .padding(25)
        }
    }
    
    func getVerificationCode() {
        Task {
            do {
                let _: String = try await APIService.shared.getVerification()
                await MainActor.run {
                    showVerificationSend = true
                }
            } catch {
                await MainActor.run {
                    showError = true
                }
            }
        }
    }
    
    func postVerificationCode() {
        Task {
            do {
                let _: String = try await APIService.shared.postVerification(body: code)
                await MainActor.run {
                    dismiss()
                    viewModel.login()
                }
            } catch {
                await MainActor.run {
                    showError = true
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var viewModel = AuthViewModel()
    ConfirmRegistrationView(viewModel: $viewModel)
}
