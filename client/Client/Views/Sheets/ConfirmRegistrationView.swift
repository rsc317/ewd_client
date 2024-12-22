//
//  ConfirmRegistrationView.swift
//  client
//
//  Created by Emircan Duman on 24.11.24.
//

import SwiftUI

struct ConfirmRegistrationView: View {
    @State var token: String = ""
    
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                ViewElementFactory.createTextfield(label: "Token", text: $token)
                ViewElementFactory.createInteractionButton(label: "Senden", action: verify)
            }
            .cornerRadius(12)
            .padding(25)
        }
    }
    
    private func verify() {
        AuthenticationManager.shared.verification(code: token)
    }
}

#Preview {
    ConfirmRegistrationView()
}
