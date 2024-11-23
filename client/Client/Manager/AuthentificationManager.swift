//
//  AuthentificationManager.swift
//  client
//
//  Created by Emircan Duman on 17.11.24.
//

import SwiftUI
import Combine


class AuthenticationManager: ObservableObject {
    var token: AuthenticationToken?
    @Published var isAuthenticated: Bool {
        didSet {
            UserDefaults.standard.set(isAuthenticated, forKey: "isLoggedIn")
        }
    }
    private var tokenTimer: Timer?

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

    func LogIn(username: String, password: String) {
        let apiService = APIService.shared

        Task {
            do {
                let requestBody = UserLoginRequest(username: username, password: password)
                let response: AuthenticationToken = try await apiService.postLogin(
                    endpoint: "auth/login",
                    body: requestBody
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
            self.clearToken()
        }
    }
    
    func register(email: String, username: String, isLoggedIn: Bool = false) {
        
    }
    
    func confirmRegistration(token: AuthenticationToken) {
        
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
        } else {
            logOut()
        }
    }
}
