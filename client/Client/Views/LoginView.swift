//
//  LoginView.swift
//  client
//
//  Created by Emircan Duman on 10.11.24.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showError: Bool = false

    var body: some View {
        ZStack {
            Color("AccentColor")
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("IconColor"))
                
                TextField("Benutzername", text: $username)
                    .padding()
                    .background(Color("Background"))
                    .cornerRadius(8)
                    .foregroundColor(.black)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                SecureField("Passwort", text: $password)
                    .padding()
                    .background(Color("Background"))
                    .cornerRadius(8)
                    .foregroundStyle(.black)
                
                Button(action: {
                    login()
                }) {
                    Text("Login")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color("InteractionColor"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                if showError {
                    Text("Ungültiger Benutzername oder Passwort")
                        .foregroundColor(.red)
                        .font(.footnote)
                }
            }
            .padding()
            .background(Color.white.opacity(0.5))
            .cornerRadius(12)
            .padding(.horizontal, 40)
        }
    }
    
    private func login() {
        if username.isEmpty || password.isEmpty {
            showError = true
        } else {
            AuthenticationManager.shared.LogIn(username: username, password: password)
            showError = false
        }
    }
}

#Preview {
    LoginView()
}
