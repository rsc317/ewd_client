//
//  DetailPinPointView.swift
//  client
//
//  Created by Emircan Duman on 01.12.24.
//

import SwiftUI

struct DetailPinPointView: View {
    @State private var viewModel: DetailPintPointViewModel
    @State private var imageResponses: [ImageResponse] = []
    @Environment(\.dismiss) var dismiss
    @FocusState private var isFocused: Bool

    init (pinPoint: PinPoint) {
        viewModel = DetailPintPointViewModel(pinPoint: pinPoint)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading) {
                            Text(viewModel.pinPoint.description)
                                .font(.body)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                .cornerRadius(10)
                        }
                        .padding()
                        PictureGalleryPreview(imageResponses: $imageResponses)
                            .padding()
                        CommentView(viewModel: $viewModel)
                            .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.vertical, 20)
                    .padding(.horizontal)
                }
                
                VStack {
                    HStack {
                        Button(action: viewModel.like) {
                            Label("\(viewModel.likeCount())", systemImage: "hand.thumbsup.fill")
                                .foregroundColor(viewModel.userReaction == .liked ? .green : .primary)
                        }
                        Button(action: viewModel.dislike) {
                            Label("\(viewModel.dislikeCount())", systemImage: "hand.thumbsdown.fill")
                                .foregroundColor(viewModel.userReaction == .disliked ? .red : .primary)
                        }
                        Spacer()
                    }
                    TextEditor(text: $viewModel.newComment)
                        .focused($isFocused)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(height: 80)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                    Button(action: {
                        viewModel.postComment()
                        viewModel.newComment = ""
                        isFocused = false
                    }) {
                        Text("Posten")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color("InteractionColor"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding(.vertical, 20)
                .padding(.horizontal)
            }
            .navigationTitle(viewModel.pinPoint.title)
            .modifier(NavigationBarTitleColorModifier(color: .icon))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(Color("AccentColor"))
                    }
                }
            }
        }
        .onAppear(perform: {
            viewModel.fetchLikesAndComments()
            self.imageResponses = [
                ImageResponse(uiImage: UIImage(imageLiteralResourceName: "default")),
                ImageResponse(uiImage: UIImage(imageLiteralResourceName: "default")),
                ImageResponse(uiImage: UIImage(imageLiteralResourceName: "default")),
                ImageResponse(uiImage: UIImage(imageLiteralResourceName: "default")),
                ImageResponse(uiImage: UIImage(imageLiteralResourceName: "default")),
                ImageResponse(uiImage: UIImage(imageLiteralResourceName: "default")),
            ]
        })
    }
}

#Preview {
    let pinPoint = PinPoint(title: "String", description: "String", duration: Duration(hours: 30, minutes: 30), coordinate: GeoCoordinate(latitude: 0, longitude: 0))
    DetailPinPointView(pinPoint: pinPoint)
}
