//
//  DetailPinPointView.swift
//  client
//
//  Created by Emircan Duman on 01.12.24.
//

import SwiftUI

struct DetailPinPointView: View {
    @State private var viewModel: DetailPintPointViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState private var isFocused: Bool
    var windows: [UIWindow] { get {
        let scenes = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return scenes?.windows ?? []
    } }
    
    init (pinPoint: PinPoint) {
        viewModel = DetailPintPointViewModel(pinPoint: pinPoint)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollViewReader { scrollView in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            NavigationLink(destination: DetailPinPointInfoView(viewModel: $viewModel)) {
                                VStack(alignment: .leading) {
                                    Text(viewModel.pinPoint.description)
                                        .font(.body)
                                        .multilineTextAlignment(.leading)
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        .lineLimit(5)
                                        .truncationMode(.tail)
                                        .cornerRadius(10)
                                        .foregroundStyle(.black)
                                }
                            }
                            .padding()
                            Divider()
                                .background(Color.gray)
                            CommentView(viewModel: $viewModel)
                                .padding()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.vertical, 20)
                        .padding(.horizontal)
                    }
                }
                
                VStack {
                    HStack {
                        Button(action: {
                            Task {
                                do {
                                    try await viewModel.postLike(true)
                                } catch {
                                    print("Fehler beim Posten eines Likes: \(error.localizedDescription)")
                                }
                            }
                        }) {
                            Label("\(viewModel.likeCount())", systemImage: "hand.thumbsup.circle.fill")
                                .foregroundColor(viewModel.userReaction == .liked ? .green : .primary)
                                .imageScale(.large)
                            
                        }
                        
                        Button(action: {
                            Task {
                                do {
                                    try await viewModel.postLike(false)
                                } catch {
                                    print("Fehler beim Posten eines Dislikes: \(error.localizedDescription)")
                                }
                            }
                        }) {
                            Label("\(viewModel.dislikeCount())", systemImage: "hand.thumbsdown.circle.fill")
                                .foregroundColor(viewModel.userReaction == .disliked ? .red : .primary)
                                .imageScale(.large)
                        }
                        Spacer()
                    }
                    VStack{
                        HStack {
                            TextField("Schreib ein Kommentar", text: $viewModel.newComment, axis: .vertical)
                                .focused($isFocused)
                                .lineLimit(7)
                                .textFieldStyle(.roundedBorder)
                            if isFocused {
                                Button(action: {
                                    isFocused = false
                                    postComment()
                                }) {
                                    Image(systemName: "paperplane.circle.fill")
                                        .font(.system(size: 22, weight: .light))
                                        .foregroundColor(.interaction)
                                }
                            }
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.vertical, 20)
                .padding(.horizontal)
            }
            .navigationTitle(viewModel.pinPoint.title)
            .toolbarTitleDisplayMode(.inlineLarge)
            .modifier(NavigationBarTitleColorModifier(color: .icon))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    VStack{
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 18, weight: .light))
                                .foregroundColor(.accentColor)
                        }
                    }
                }
            }
        }
        .onAppear {
            fetchLikesAndComments()
        }
    }
    
    func fetchLikesAndComments() {
        Task {
            do {
                try await viewModel.fetchLikesAndComments()
            } catch {
                print("Fehler beim Laden der Daten: \(error)")
            }
        }
    }
    
    func postComment() {
        Task {
            do {
                try await viewModel.postComment()
            } catch {
                print("Fehler beim Laden der Daten: \(error)")
            }
        }
    }
    
    func postLike(_ like: Bool) {
        Task {
            do {
                try await viewModel.postLike(like)
            } catch {
                print("Fehler beim Laden der Daten: \(error)")
            }
        }
    }
}

#Preview {
    let pinPoint = PinPoint(title: "String", description: "String", duration: Duration(hours: 30, minutes: 30), coordinate: GeoCoordinate(latitude: 0, longitude: 0))
    DetailPinPointView(pinPoint: pinPoint)
}
