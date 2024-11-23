//
//  ContentView.swift
//  client
//
//  Created by Emircan Duman on 06.11.24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedTab = 2
//    @Query private var items: [Item]

    var body: some View {
        TabView(selection: $selectedTab){
            
            PostsView()
                .tabItem {
                    Label("my_posts", systemImage: "ellipses.bubble")
                }
                .tag(1)
            MapView()
                .tabItem {
                    Label("map", systemImage: "map")
                }
                .tag(2)
            SettingsView()
                .tabItem {
                    Label("settings", systemImage: "gearshape")
                }
                .tag(3)
        }
    }
}

#Preview {
    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
}
