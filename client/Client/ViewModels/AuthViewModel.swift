//
//  AuthViewModel.swift
//  client
//
//  Created by Emircan Duman on 01.01.25.
//

import Foundation


@Observable
class AuthViewModel {
    
    enum ValidationError: Error, Identifiable {
        var id: Self { self }
        case usernameToShort
        case passwordToShort
        case passwordNoSpecialCharacter
        case passwordNoCapitalCharacter
        case passwordHasInvalidCharacter
        case passwordNotMatch
        case emailInvalid
    }
    
    enum LoginError: Error, Identifiable {
        var id: Self { self }
        case badCredentials
    }
    
    enum PasswordResetError: Error, Identifiable {
        var id: Self { self }
        case badCredentials
        case requestFailed
    }
    
    private(set) var validationErrors: [ValidationError] = []
    private var authManager = AuthenticationManager.shared
    
    var username: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var email: String = ""
    var showConfirmRegistrationView: Bool = false
    var apiService = APIService.shared
    
    func registrate() {
        hasValidationErrors()
        Task {
            if validationErrors.isEmpty {
                let body = UserRegistrationRequest(username: username, email: email, password: password)
                do {
                    let _: String = try await apiService.postSignUp(body: body)
                    try await authManager.logIn(username: username, password: password)
                    let _: String = try await apiService.getVerification()
                    try await login()
                } catch {
                    
                }
            }
        }
    }
    
    func login() async throws(LoginError) {
        do {
            try await authManager.logIn(username: username, password: password)
            await MainActor.run {
                showConfirmRegistrationView = !authManager.isUserVerified
            }
        } catch {
            throw LoginError.badCredentials
        }
    }
    
    func sendPasswordRequest() async throws(PasswordResetError) {
        if hasPasswordFotgotErrors() {
            throw PasswordResetError.badCredentials
        }
        do {
            let body = PasswordForgotRequest(email: email)
            let _: String = try await apiService.postPasswordRequest(body: body)
        } catch {
            throw PasswordResetError.requestFailed
        }
    }
    
    func sendPasswordConfirmRequest(token: String) async throws(PasswordResetError) {
        if hasPasswordFotgotErrors() {
            throw PasswordResetError.badCredentials
        }
        do {
            let body = PasswordForgotConfirmRequest(token: token, password: password)
            let _: String = try await apiService.postPasswordResetConfirm(body: body)
        } catch {
            throw PasswordResetError.requestFailed
        }
    }
    
    func reset() {
        validationErrors = []
        username = ""
        password = ""
        confirmPassword = ""
        email = ""
        showConfirmRegistrationView = false
    }
    
    private func hasPasswordFotgotErrors() -> Bool {
        return !isValidEmail(email) || password != confirmPassword || password.count < 8 || password.rangeOfCharacter(from: .uppercaseLetters) == nil || password.rangeOfCharacter(from: CharacterSet(charactersIn: "!@#$%^&*()-_=+{}|:,.<>?")) == nil || password.rangeOfCharacter(from: CharacterSet(charactersIn: "<>'\"\\/;")) != nil
    }
    
    func hasValidationErrors() {
        validationErrors.removeAll()
        if !isValidEmail(email) {
            validationErrors.append(.emailInvalid)
        }
        if username.isEmpty || username.count < 4 {
            validationErrors.append(.usernameToShort)
        }
        if password != confirmPassword {
            validationErrors.append(.passwordNotMatch)
        }
        if password.count < 8 {
            validationErrors.append(.passwordToShort)
        }
        if password.rangeOfCharacter(from: .uppercaseLetters) == nil {
            validationErrors.append(.passwordNoCapitalCharacter)
        }
        if password.rangeOfCharacter(from: CharacterSet(charactersIn: "!@#$%^&*()-_=+{}|:,.<>?")) == nil {
            validationErrors.append(.passwordNoSpecialCharacter)
        }
        if password.rangeOfCharacter(from: CharacterSet(charactersIn: "<>'\"\\/;")) != nil {
            validationErrors.append(.passwordHasInvalidCharacter)
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
