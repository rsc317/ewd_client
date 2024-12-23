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
                } else if showError {
                    
                }

                ViewElementFactory.createInteractionButton(label: "Verifizieren", action: verify)
                    .padding(.horizontal, 10)
            }
            .cornerRadius(12)
            .padding(25)
        }
    }
    
    private func verify() {
        let errors = AuthenticationManager.shared.verification(code: token)
        
    }
                     
    private func sendVerification() {
        Task {
            let errors = await AuthenticationManager.shared.verification()
            showVerificationSend = errors.isEmpty
        }
    }
}

#Preview {
    ConfirmRegistrationView()
}
