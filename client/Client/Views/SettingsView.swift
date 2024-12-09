//
//  SettingsView.swift
//  client
//
//  Created by Emircan Duman on 10.11.24.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("radiusValue") private var radiusValue: Double = 50.0
    
    var body: some View {
        NavigationStack {
            List {
                Section{
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "globe.americas.fill")
                                .foregroundColor(.interaction)
                                .frame(width: 24, height: 24)
                            Text("Radius")
                                .foregroundColor(.primary)
                            Spacer()
                            Text("\(Int(radiusValue)) m")
                                .foregroundColor(.gray)
                        }
                        Slider(value: $radiusValue, in: 0...1000, step: 1)
                            .accentColor(.blue)
                    }
                    .padding(.vertical, 8)
                }
                
                Section{
                    Button(action: {
                        logout()
                    }) {
                        Text("Logout")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.interaction)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Einstellungen")
            .modifier(NavigationBarTitleColorModifier(color: .icon))
        }
        .padding()
        .background(Color(UIColor.systemGroupedBackground))

    }
    
    func logout() {
        AuthenticationManager.shared.logOut()
    }
}

#Preview {
    SettingsView()
}
