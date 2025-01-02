//
//  AuthentificationManager.swift
//  client
//
//  Created by Emircan Duman on 17.11.24.
//
import SwiftUI
import Combine
import Security

enum AuthenticationError: Error, Identifiable {
    var id: Self { self }
    case usernameAlreadyInUse
    case usernameToShort
    case userNotFound
    case passwordToShort
    case passwordNoSpecialCharacter
    case passwordNoCapitalCharacter
    case passwordHasInvalidCharacter
    case passwordNotMatch
    case emailAlreadyInUse
    case emailInvalid
    case accountNotConfirmed
    case networkError
    case unknownError
    case registrationError
    case loginError
    case userNotVerifiedError
    case credentialsError
    case verificationError
}

class AuthenticationManager: ObservableObject {
    @AppStorage("isAuthenticated") var isAuthenticated: Bool = false
    @AppStorage("stayLoggedIn") var stayLoggedIn: Bool = false
    @AppStorage("storedUsername") var storedUsername: String = ""
    var isUserVerified: Bool {
        if let token {
            return token.userVerified
        } else {
            return false
        }
    }
    var token: AuthenticationToken?
    private var tokenTimer: Timer?
    private var countdownTimer: Timer?

    static let shared = AuthenticationManager()
    
    private init() {
        self.token = loadTokenFromKeychain()

        if stayLoggedIn {
            if let token = self.token, isTokenValid(token: token) {
                scheduleTokenExpiration(token: token)
            } else if let username = storedUsername.nonEmpty, let password = loadPasswordFromKeychain(for: username) {
                Task {
                    let error = await self.logIn(username: username, password: password, silentLogin: true)
                    if error != nil {
                        DispatchQueue.main.async { [self] in
                            logOut()
                        }
                    }
                }
            } else {
                logOut()
            }
        } else {
            logOut()
        }
    }

    func logIn(username: String, password: String, silentLogin: Bool = false) async -> AuthenticationError? {
        let apiService = APIService.shared
        
        do {
            let credentials = "\(username):\(password)"
            guard let encodedCredentials = credentials.data(using: .utf8)?.base64EncodedString() else {
                return .credentialsError
            }
            
            let response: AuthenticationToken = try await apiService.getLogin(
                endpoint: "auth/login",
                headers: ["Authorization": "Basic \(encodedCredentials)", "Content-Type": "application/json"]
            )
            
            await MainActor.run {
                self.tokenTimer?.invalidate()
                self.token = response
                self.isAuthenticated = true
                if self.stayLoggedIn {
                    self.storedUsername = username
                    self.savePasswordToKeychain(password, for: username)
                } else {
                    self.storedUsername = ""
                    self.deletePasswordFromKeychain(for: username)
                }
                self.saveTokenToKeychain(response)
                self.scheduleTokenExpiration(token: response)
            }
            
            if !response.userVerified {
                return .userNotVerifiedError
            }

        } catch {
            print("CATCH")
            
            await MainActor.run {
                if !silentLogin {
                    self.logOut()
                }
            }
            return .credentialsError
        }
        return nil
    }

    func logOut() {
        DispatchQueue.main.async {
            self.isAuthenticated = false
            self.stayLoggedIn = false
            self.token = nil
            self.tokenTimer?.invalidate()
            self.countdownTimer?.invalidate()
            if let username = self.storedUsername.nonEmpty {
                self.deletePasswordFromKeychain(for: username)
            }
            self.storedUsername = ""
            self.clearTokenFromKeychain()
        }
    }

    func signUp(email: String, username: String, password: String, passwordConfirm: String) -> [AuthenticationError] {
        var authenticationErrors = checkForErrors(email: email, username: username, password: password, passwordConfirm: passwordConfirm)
        if authenticationErrors.isEmpty {
            let apiService = APIService.shared
            Task {
                do {
                    let requestBody = UserRegistrationRequest(username: username, email: email, password: password)
                    let _: String = try await apiService.postSignUp(endpoint: "auth/signup", body: requestBody)
                    self.token = try await self.performLogin(username: username, password: password)
                    let _: String = try await apiService.getVerification(endpoint: "user/verification")
                } catch {
                    authenticationErrors.append(.registrationError)
                }
            }
        }
        return authenticationErrors
    }
    
    func verification(code: String) async -> AuthenticationError? {
        do {
            let _: String = try await APIService.shared.postVerification(endpoint: "user/verification", body: code)
            return nil
        } catch {
            print("VERIFICATION ERROR 1")
            return AuthenticationError.verificationError
        }
        return nil
    }
    
    func verification() async -> AuthenticationError? {
        do {
            let _: String = try await APIService.shared.getVerification(endpoint: "user/verification")
            return nil
        } catch {
            print("VERIFICATION ERROR 2")
            return AuthenticationError.verificationError
        }
        return nil
    }
    
    private func checkForErrors(email: String, username: String, password: String, passwordConfirm: String) -> [AuthenticationError] {
        var authenticationErros: [AuthenticationError] = []
        if isUsernameInUse(username) {
            authenticationErros.append(.usernameAlreadyInUse)
        }
        if isEmailInUse(email) {
            authenticationErros.append(.emailAlreadyInUse)
        }
        if !isValidEmail(email) {
            authenticationErros.append(.emailInvalid)
        }
        if username.isEmpty || username.count < 3 {
            authenticationErros.append(.usernameToShort)
        }
        if password != passwordConfirm {
            authenticationErros.append(.passwordNotMatch)
        }
        if password.count < 8 {
            authenticationErros.append(.passwordToShort)
        }
        if password.rangeOfCharacter(from: .uppercaseLetters) == nil {
            authenticationErros.append(.passwordNoCapitalCharacter)
        }
        if password.rangeOfCharacter(from: CharacterSet(charactersIn: "!@#$%^&*()-_=+{}|:,.<>?")) == nil {
            authenticationErros.append(.passwordNoSpecialCharacter)
        }
        if password.rangeOfCharacter(from: CharacterSet(charactersIn: "<>'\"\\/;")) != nil {
            authenticationErros.append(.passwordHasInvalidCharacter)
        }
        return authenticationErros
    }
    
    private func isUsernameInUse(_ username: String) -> Bool {
        return false
    }
    
    private func isEmailInUse(_ email: String) -> Bool {
        return false
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func saveTokenToKeychain(_ token: AuthenticationToken) {
        do {
            let tokenData = try JSONEncoder().encode(token)
            saveToKeychain(account: "authToken", data: tokenData)
        } catch {}
    }
    
    private func loadTokenFromKeychain() -> AuthenticationToken? {
        guard let tokenData = loadFromKeychain(account: "authToken") else { return nil }
        do {
            return try JSONDecoder().decode(AuthenticationToken.self, from: tokenData)
        } catch {
            return nil
        }
    }
    
    private func clearTokenFromKeychain() {
        deleteFromKeychain(account: "authToken")
    }

    private func savePasswordToKeychain(_ password: String, for username: String) {
        guard let passwordData = password.data(using: .utf8) else { return }
        saveToKeychain(account: "password_\(username)", data: passwordData)
    }

    private func loadPasswordFromKeychain(for username: String) -> String? {
        guard let data = loadFromKeychain(account: "password_\(username)"),
              let password = String(data: data, encoding: .utf8) else {
            return nil
        }
        return password
    }

    private func deletePasswordFromKeychain(for username: String) {
        deleteFromKeychain(account: "password_\(username)")
    }

    private func isTokenValid(token: AuthenticationToken) -> Bool {
        return Date() < token.expireDate
    }
    
    private func scheduleTokenExpiration(token: AuthenticationToken) {
        let timeInterval = token.expireDate.timeIntervalSinceNow
        
        if timeInterval > 0 {
            tokenTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { [weak self] _ in
                self?.attemptReLoginOrLogout()
            }
            startCountdownTimer(until: token.expireDate)
        } else {
            attemptReLoginOrLogout()
        }
    }

    private func attemptReLoginOrLogout() {
        guard let username = storedUsername.nonEmpty,
              let password = loadPasswordFromKeychain(for: username) else {
            logOut()
            return
        }
        
        Task {
            do {
                let newToken = try await performLogin(username: username, password: password)
                DispatchQueue.main.async {
                    self.token = newToken
                    self.isAuthenticated = true
                    self.saveTokenToKeychain(newToken)
                    self.scheduleTokenExpiration(token: newToken)
                }
            } catch {
                DispatchQueue.main.async {
                    self.logOut()
                }
            }
        }
    }

    private func performLogin(username: String, password: String) async throws -> AuthenticationToken {
        let credentials = "\(username):\(password)"
        guard let encodedCredentials = credentials.data(using: .utf8)?.base64EncodedString() else {
            throw AuthenticationError.unknownError
        }
        let headers = ["Authorization":"Basic \(encodedCredentials)","Content-Type":"application/json"]
        return try await APIService.shared.getLogin(endpoint: "auth/login", headers: headers)
    }

    private func startCountdownTimer(until date: Date) {
        countdownTimer?.invalidate()
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if date.timeIntervalSinceNow <= 0 {
                timer.invalidate()
            }
        }
    }
    
    private func saveToKeychain(account: String, data: Data) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary)
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]
        SecItemAdd(attributes as CFDictionary, nil)
    }
    
    private func loadFromKeychain(account: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess, let data = result as? Data else {
            return nil
        }
        return data
    }
    
    private func deleteFromKeychain(account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary)
    }
}
