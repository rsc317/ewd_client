//
//  PostsView.swift
//  client
//
//  Created by Emircan Duman on 10.11.24.
//

import SwiftUI


struct PostsView: View {
    @State private var viewModel = PostsViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.pinPoints.isEmpty {
                    VStack {
                        Text("Keine Einträge vorhanden")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(UIColor.systemGray5))
                } else {
                    ScrollView {
                        VStack(spacing: 8) {
                            ForEach(viewModel.pinPoints, id: \.id) { pinPoint in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(pinPoint.title)
                                        .font(.headline)
                                        .foregroundColor(Color.icon)
                                        .padding(.bottom, 4)
                                    HStack {
                                        Image(systemName: "hourglass.circle")
                                        Text(pinPoint.duration.endDate, style: .time)
                                            .font(.caption)
                                            .foregroundColor(.primary)
                                    }
                                    HStack {
                                        Image(systemName: "globe")
                                        Text(pinPoint.getPrettyPrint())
                                            .font(.caption)
                                            .foregroundColor(.primary)
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(UIColor.systemGroupedBackground))
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.1), radius: 12, x: 0, y: 12)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .background(Color(UIColor.systemGray5))
            .navigationTitle("Posts")
            .modifier(NavigationBarTitleColorModifier(color: .icon))
        }
        .listStyle(.insetGrouped)
        .onAppear {
            fetchPinPoints()
        }
    }
    
    private func fetchPinPoints() {
        Task {
            do {
                try await viewModel.fetchMyPinPoints()
            } catch {
                print("Fehler beim Laden der Daten: \(error)")
            }
        }
    }
}

#Preview {
    PostsView()
}
