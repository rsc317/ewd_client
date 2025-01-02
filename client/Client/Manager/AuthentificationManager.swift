//
//  AuthentificationManager.swift
//  client
//
//  Created by Emircan Duman on 17.11.24.
//
import SwiftUI
import Combine
import Security


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
    
    @Published var token: AuthenticationToken?
    
    static let shared = AuthenticationManager()
    
    private init() {
        self.token = loadTokenFromKeychain()
        
        if stayLoggedIn {
            if let username = storedUsername.nonEmpty, let password = loadPasswordFromKeychain(for: username) {
                Task {
                    do {
                        try await self.logIn(username: username, password: password, silentLogin: true)
                    } catch {}
                }
            } else {
                logOut()
            }
        } else {
            logOut()
        }
    }
    
    func logIn(username: String, password: String, silentLogin: Bool = false) async throws {
        let apiService = APIService.shared
    
        guard let headers = createAuthHeaders(username: username, password: password) else {
            logOut()
            return
        }
        
        let response: AuthenticationToken = try await apiService.getLogin(headers: headers)
        await MainActor.run {
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
        }
    }
    
    func logOut() {
        DispatchQueue.main.async {
            self.isAuthenticated = false
            self.stayLoggedIn = false
            self.token = nil
            if let username = self.storedUsername.nonEmpty {
                self.deletePasswordFromKeychain(for: username)
            }
            self.storedUsername = ""
            self.clearTokenFromKeychain()
        }
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
    
    func attemptReLoginOrLogout() {
        guard let username = storedUsername.nonEmpty,
              let password = loadPasswordFromKeychain(for: username) else {
            logOut()
            return
        }
        
        Task {
            do {
                guard let headers = createAuthHeaders(username: username, password: password) else {
                    logOut()
                    return
                }
                
                let newToken: AuthenticationToken = try await APIService.shared.getLogin(headers: headers)
                
                await MainActor.run {
                    self.token = newToken
                    self.isAuthenticated = true
                    self.saveTokenToKeychain(newToken)
                }
            } catch {
                await MainActor.run {
                    logOut()
                }
            }
        }
    }
    
    private func createAuthHeaders(username: String, password: String) -> [String: String]? {
        guard let credentials = "\(username):\(password)".data(using: .utf8)?.base64EncodedString() else {
            return nil
        }
        
        return [
            "Authorization": "Basic \(credentials)",
            "Content-Type": "application/json"
        ]
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
