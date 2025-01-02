//
//  ConfirmRegistrationView.swift
//  client
//
//  Created by Emircan Duman on 24.11.24.
//

import SwiftUI

struct ConfirmRegistrationView: View {
    @State var token: String = ""
    @State var error: AuthenticationError? = nil
    @State var showVerificationSend: Bool = false
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
                                                   text: $token,
                                                   accessibilityId: accessibilityIdentifiers.VERIFICATION_TOKEN_FIELD)
                    .padding(.horizontal, 10)
                
                ViewElementFactory.createInteractionFooter(
                    footerText: "Bitte überprüfen Sie ihre Emails!",
                    footerButtonText: "Nochmal senden?",
                    action: sendVerification,
                    accessibilityId: accessibilityIdentifiers.SEND_VERIFICATION_CODE_BUTTON
                )
                
                if showVerificationSend {
                    Text(localizationIdentifiers.CODE_WAS_SENT.localized)
                        .foregroundStyle(.success)
                        .font(.footnote)
                }
                
                if error != nil {
                    Text(localizationIdentifiers.WRONG_CODE.localized)
                        .foregroundStyle(.success)
                        .font(.footnote)
                }

                ViewElementFactory.createInteractionButton(label: "Verifizieren",
                                                           action: verify,
                                                           accessibilityId: accessibilityIdentifiers.VERIFICATION_BUTTON)
                    .padding(.horizontal, 10)
            }
            .cornerRadius(12)
            .padding(25)
        }
    }
    
    private func verify() {
        showVerificationSend = false
        Task {
            error = try await AuthenticationManager.shared.verification(code: token)
            DispatchQueue.main.async {
                if error == nil {
                    dismiss()
                }
            }
        }
    }

    private func sendVerification() {
        showVerificationSend = false
        Task {
            error = await AuthenticationManager.shared.verification()
            DispatchQueue.main.async {
                showVerificationSend = (error == nil)
            }
        }
    }
}

#Preview {
    ConfirmRegistrationView()
}
