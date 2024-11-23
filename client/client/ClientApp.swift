//
//  ClientApp.swift
//  Client
//
//  Created by Emircan Duman on 06.11.24.
//

import SwiftUI
import SwiftData

@main
struct ClientApp: App {
    @StateObject private var authenticator = AuthenticationManager.shared

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            if authenticator.isAuthenticated {
                ContentView()
            } else {
                LoginView()
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
