//
//  SettingsView.swift
//  client
//
//  Created by Emircan Duman on 10.11.24.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Spacer()
            Button(action: {
                logout()
            }) {
                Text("Logout")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color("InteractionColor"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
    
    func logout() {
        AuthenticationManager.shared.logOut()
    }
}

#Preview {
    SettingsView()
}
