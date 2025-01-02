//
//  ConfirmRegistrationView.swift
//  client
//
//  Created by Emircan Duman on 24.11.24.
//

import SwiftUI

struct ConfirmRegistrationView: View {
    @State var token: String = ""
    @State var errors: [AuthenticationError] = []
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
                ViewElementFactory.createTextfield(label: "Code", text: $token)
                    .padding(.horizontal, 10)
                
                ViewElementFactory.createInteractionFooter(
                    footerText: "Bitte überprüfen Sie ihre Emails!",
                    footerButtonText: "Nochmal senden?",
                    action: sendVerification
                )
                
                if showVerificationSend {
                    Text("Code wurde versendet! Gucke in dein Postfach!")
                        .foregroundStyle(.success)
                        .font(.footnote)
                }
                
                if showError {
                    Text("Ein Fehler ist aufgetreten!")
                        .foregroundStyle(.success)
                        .font(.footnote)
                }

                ViewElementFactory.createInteractionButton(label: "Verifizieren", action: verify)
                    .padding(.horizontal, 10)
            }
            .cornerRadius(12)
            .padding(25)
        }
    }
    
    private func verify() {
        showError = false
        showVerificationSend = false
        Task {
            let errors = await AuthenticationManager.shared.verification(code: token)
            DispatchQueue.main.async {
                if !errors.isEmpty {
                    showError = true
                } else {
                    dismiss
                }
            }
        }
    }
                     
    private func sendVerification() {
        showVerificationSend = false
        showError = false
        Task {
            let errors = await AuthenticationManager.shared.verification()
            DispatchQueue.main.async {
                showVerificationSend = errors.isEmpty
            }
        }
    }
}

#Preview {
    ConfirmRegistrationView()
}
