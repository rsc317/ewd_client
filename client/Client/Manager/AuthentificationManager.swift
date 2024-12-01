//
//  AuthentificationManager.swift
//  client
//
//  Created by Emircan Duman on 17.11.24.
//

import SwiftUI
import Combine

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
}

class AuthenticationManager: ObservableObject {
    var token: AuthenticationToken?
    @Published var isAuthenticated: Bool {
        didSet {
            UserDefaults.standard.set(isAuthenticated, forKey: "isLoggedIn")
        }
    }
    private var tokenTimer: Timer?
    private var countdownTimer: Timer?

    static let shared = AuthenticationManager()
    
    private init() {
        self.isAuthenticated = UserDefaults.standard.bool(forKey: "isLoggedIn")
        self.token = loadToken()
        
        if let token = self.token, isTokenValid() {
            scheduleTokenExpiration()
            print("Token geladen und gültig: \(token.token)")
        } else {
            logOut()
        }
    }

    func logIn(username: String, password: String) {
        let apiService = APIService.shared

        Task {
            do {
                let credentials = "\(username):\(password)"
                guard let encodedCredentials = credentials.data(using: .utf8)?.base64EncodedString() else {
                    return //throw APIError.authFailed(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Ungültige Anmeldedaten"]))
                }
                let headerField = "Authorization"
                let headerValue = "Basic \(encodedCredentials)"
                let response: AuthenticationToken = try await apiService.getLogin(
                    endpoint: "auth/login",
                    headers: [headerField:headerValue]
                )
                DispatchQueue.main.async {
                    self.tokenTimer?.invalidate()
                    self.token = response
                    self.isAuthenticated = true
                    self.saveToken(response)
                    self.scheduleTokenExpiration()
                }
            } catch {
                print("Fehler: \(error)")
            }
        }
    }

    func logOut() {
        DispatchQueue.main.async {
            self.isAuthenticated = false
            self.token = nil
            self.tokenTimer?.invalidate()
            self.countdownTimer?.invalidate()
            self.clearToken()
        }
    }
    
    func signUp(email: String, username: String, password: String, passwordConfirm: String) -> [AuthenticationError] {
        let authenticationErrors: [AuthenticationError] = checkForErrors(email: email, username: username, password: password, passwordConfirm: passwordConfirm)
        
        if authenticationErrors.isEmpty {
            let apiService = APIService.shared

            Task {
                do {
                    let requestBody = UserRegistrationRequest(username: username, email: email, password: password)
                    let _ : String = try await apiService.postSignUp(
                        endpoint: "auth/signup",
                        body: requestBody
                    )
                } catch {
                    print("Fehler: \(error)")
                }
            }
        }
        
        return authenticationErrors
    }
    
    private func checkForErrors(email: String, username: String, password: String, passwordConfirm: String) -> [AuthenticationError] {
        var authenticationErros: [AuthenticationError] = []
        
        if isUsernameInUse(username) {
            authenticationErros.append(.usernameAlreadyInUse)
        }
        if isEmailInUse(email) {
            authenticationErros.append(.emailAlreadyInUse)
        }
        if isValidEmail(email) {
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
        //@TODO implement rest call to check if username is in use
        return false
    }
    
    private func isEmailInUse(_ username: String) -> Bool {
        //@TODO implement rest call to check if email is in use
        return false
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func saveToken(_ token: AuthenticationToken) {
        let defaults = UserDefaults.standard
        do {
            let tokenData = try JSONEncoder().encode(token)
            defaults.set(tokenData, forKey: "authToken")
            defaults.set(token.expireDate, forKey: "tokenExpireDate")
            print("Token und Ablaufdatum gespeichert.")
        } catch {
            print("Fehler beim Speichern des Tokens: \(error)")
        }
    }
    
    private func loadToken() -> AuthenticationToken? {
        let defaults = UserDefaults.standard
        guard let tokenData = defaults.data(forKey: "authToken") else {
            return nil
        }
        do {
            return try JSONDecoder().decode(AuthenticationToken.self, from: tokenData)
        } catch {
            print("Fehler beim Laden des Tokens: \(error)")
            return nil
        }
    }
    
    private func clearToken() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "authToken")
        defaults.removeObject(forKey: "tokenExpireDate")
    }
    
    private func isTokenValid() -> Bool {
        guard let token = token else {
            print("Kein Token vorhanden.")
            return false
        }
        let valid = Date() < token.expireDate
        print("Token gültig: \(valid)")
        return valid
    }
    
    private func scheduleTokenExpiration() {
        guard let expireDate = UserDefaults.standard.object(forKey: "tokenExpireDate") as? Date else {
            print("Kein Ablaufdatum gefunden.")
            return
        }

        let timeInterval = expireDate.timeIntervalSinceNow
        print("Token läuft ab in \(timeInterval / 60 / 60) Minuten.")

        if timeInterval > 0 {
            tokenTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { [weak self] _ in
                self?.logOut()
                print("Token abgelaufen. Benutzer wurde abgemeldet.")
            }

            countdownTimer?.invalidate()
            countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
                guard let self = self else { return }

                let remainingTime = expireDate.timeIntervalSinceNow
                if remainingTime > 0 {
                    print("Verbleibende Zeit: \(String(format: "%.0f", remainingTime)) Sekunden")
                } else {
                    timer.invalidate()
                }
            }
        } else {
            logOut()
        }
    }
}
