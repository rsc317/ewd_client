//
//  DetailPintPointViewModel.swift
//  client
//
//  Created by Emircan Duman on 05.12.24.
//

import Foundation

enum UserReaction {
    case none
    case liked
    case disliked
}

@Observable
class DetailPintPointViewModel {
    private(set) var pinPoint: PinPoint
    
    var userReaction: UserReaction = .none
    var newComment: String = ""
    var isLoading: Bool = false
    var errorMessage: String?
    
    init(pinPoint: PinPoint) {
        self.pinPoint = pinPoint
    }
    
    func fetchLikesAndComments() {
        //Please remove when endpoints are implemented
        mockLikesAndComments()
    }
    
    func dislike() {
        postLike(false)
        userReaction = .disliked
    }
    
    func like() {
        postLike(true)
        userReaction = .liked
    }
    
    func dislikeCount() -> Int {
        pinPoint.likes.filter { !$0.isLike }.count
    }
    
    func likeCount() -> Int {
        pinPoint.likes.filter { $0.isLike }.count
    }

    func postComment() {
        
    }
    
    private func postLike(_ liked: Bool) {
        
    }
    
    private func mockLikesAndComments() {
        pinPoint.likes = [Like(isLike: true),Like(isLike: true),Like(isLike: true),Like(isLike: true),Like(isLike: false),Like(isLike: true),Like(isLike: false),Like(isLike: false),Like(isLike: true),Like(isLike: false),Like(isLike: true),Like(isLike: true),]
        pinPoint.comments = [
            Comment(message: "Das ist ein großartiger Beitrag!", username: "Max"),
            Comment(message: "Ich stimme voll und ganz zu.", username: "Julia"),
            Comment(message: "Vielen Dank für die Information.", username: "Leon"),
            Comment(message: "Können Sie mehr Details bereitstellen?", username: "Sofia"),
            Comment(message: "Ich habe eine andere Meinung.", username: "Lukas")
        ]
    }
}
