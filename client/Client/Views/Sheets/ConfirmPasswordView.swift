//
//  ConfirmPasswordView.swift
//  client
//
//  Created by Emircan Duman on 12.01.25.
//

import SwiftUI

struct ConfirmPasswordView: View {
    @Binding var viewModel: AuthViewModel
    @State var token: String = ""
    let onDismiss: () -> Void

    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Image(systemName: "person.badge.key.fill")
                    .foregroundStyle(.icon)
                    .font(.system(size: 100))
                Text("Zurücksetzungs Code")
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundStyle(.icon)
                ViewElementFactory.createTextfield(label: "Token",
                                                   text: $token,
                                                   accessibilityId: accessibilityIdentifiers.PASSWORD_RESET_TOKEN)
                .padding(.horizontal, 10)
                
                ViewElementFactory.createInteractionButton(label: "Bestätigen", action: submitPasswordReset,
                                                           accessibilityId: accessibilityIdentifiers.VERIFICATION_BUTTON)
                
                .padding(.horizontal, 10)
            }
            .cornerRadius(12)
            .padding(25)
        }
    }
    
    func submitPasswordReset() {
        Task {
            do {
                try await viewModel.sendPasswordConfirmRequest(token: token)
                self.onDismiss()
                viewModel.reset()
            } catch {
     
            }
        }
    }
}

#Preview {
    @Previewable @State var viewModel = AuthViewModel()
    ConfirmPasswordView(viewModel: $viewModel, onDismiss: {})
}
