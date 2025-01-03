//
//  ConfirmRegistrationView.swift
//  client
//
//  Created by Emircan Duman on 24.11.24.
//

import SwiftUI

struct ConfirmRegistrationView: View {
    @Binding var viewModel: AuthViewModel
    @State var statusMsg: String? = nil
    @State var code: String = ""
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
                
                if let statusMsg = statusMsg {
                    Text(statusMsg)
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
                    statusMsg = localizationIdentifiers.CODE_WAS_SENT.localized
                }
            } catch {
                await MainActor.run {
                    statusMsg = localizationIdentifiers.CODE_NOT_SENT.localized
                }
            }
        }
    }
    
    func postVerificationCode() {
        Task {
            do {
                let _: String = try await APIService.shared.postVerification(body: code)
                try await viewModel.login()

                await MainActor.run {
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    statusMsg = localizationIdentifiers.WRONG_CODE.localized
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var viewModel = AuthViewModel()
    ConfirmRegistrationView(viewModel: $viewModel)
}
