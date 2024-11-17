//
//  AuthentificationManager.swift
//  client
//
//  Created by Emircan Duman on 17.11.24.
//

import SwiftUI
import Combine


class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: User?

    static let shared = AuthenticationManager()

    private init() {}

    func signIn(email: String, password: String) {
        /**
         @TODO Remove mock and implement logic to authentification user on backend
         */
        let user = User.mock()
        DispatchQueue.main.async {
            self.currentUser = user
            self.isAuthenticated = true
        }
    }

    func signOut() {
        DispatchQueue.main.async {
            self.currentUser = nil
            self.isAuthenticated = false
        }
    }
    
    func register(email: String, username: String, isLoggedIn: Bool = false) {
        
    }
    
    func confirmRegistration(token: AuthenticationToken) {
        
    }
}
