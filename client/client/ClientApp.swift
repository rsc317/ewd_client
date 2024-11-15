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
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            AuthenticationToken.self,
            User.self,
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
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
