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
    private(set) var comments: [Comment] = []
    private(set) var likes: [Like] = []
    var pinPointImages: [ImageResponse] = []
    
    var userReaction: UserReaction = .none
    var newComment: String = ""
    var isLoading: Bool = false
    var errorMessage: String?
    
    init(pinPoint: PinPoint) {
        self.pinPoint = pinPoint
    }
    
    func fetchLikesAndComments() async throws {
        isLoading = true
        errorMessage = nil
        comments = []
        likes = []
        do {
            guard let pinPointId = pinPoint.serverId else { return }
            let fetchedComments: [Comment] = try await APIService.shared.get(endpoint: "pinpoints/\(pinPointId)/comments")
            let fetchedLikes: [Like] = try await APIService.shared.get(endpoint: "pinpoints/\(pinPointId)/likes")
            comments.append(contentsOf: fetchedComments)
            likes.append(contentsOf: fetchedLikes)
        } catch {
            if let apiError = error as? APIError {
                self.errorMessage = apiError.localizedDescription
            } else {
                self.errorMessage = error.localizedDescription
            }
        }
        isLoading = false
    }
    
    func dislikeCount() -> Int {
        likes.filter { !$0.isLike }.count
    }
    
    func likeCount() -> Int {
        likes.filter { $0.isLike }.count
    }

    func postComment() async throws {
        isLoading = true
        errorMessage = nil
        
        let newComment = Comment(content: newComment)
        
        do {
            guard let pinPointId = pinPoint.serverId else { return }
            let responseMsg:String = try await APIService.shared.post(endpoint: "pinpoints/\(pinPointId)/comments", body: newComment)
            print("server msg:\(responseMsg)")
        } catch {
            if let apiError = error as? APIError {
                self.errorMessage = apiError.localizedDescription
            } else {
                self.errorMessage = error.localizedDescription
            }
            print("posting comment failed:\(self.errorMessage!)")
        }
        Task {
            do {
                try await self.fetchLikesAndComments()
            } catch {
                print("Fehler beim Laden der Daten: \(error)")
            }
        }
        isLoading = false
        self.newComment = ""

    }
    
    func postLike(_ like: Bool) async throws {
        isLoading = true
        errorMessage = nil
        userReaction = like ? .liked : .disliked
        
        let newLike = Like(isLike: like)
        
        do {
            guard let pinPointId = pinPoint.serverId else { return }

            let responseMsg:String = try await APIService.shared.post(endpoint: "pinpoints/\(pinPointId)/likes", body: newLike)
            print("server msg:\(responseMsg)")
        } catch {
            if let apiError = error as? APIError {
                self.errorMessage = apiError.localizedDescription
            } else {
                self.errorMessage = error.localizedDescription
            }
            print("posting like failed:\(self.errorMessage!)")
        }
        Task {
            do {
                try await self.fetchLikesAndComments()
            } catch {
                print("Fehler beim Laden der Daten: \(error)")
            }
        }
        isLoading = false
    }
    
    func fetchImages() async throws {
        isLoading = true
        errorMessage = nil
        pinPointImages = []
        
        do {
            guard let pinPointId = pinPoint.serverId else { return }
            let fetchedImages: [ImageResponse] = try await APIService.shared.get(endpoint: "pinpoints/\(pinPointId)/images")
            pinPointImages.append(contentsOf: fetchedImages)
        } catch {
            if let apiError = error as? APIError {
                self.errorMessage = apiError.localizedDescription
            } else {
                self.errorMessage = error.localizedDescription
            }
        }
        isLoading = false
    }
    
    func hasAddress() -> Bool {
        if let address = pinPoint.coordinate.address {
            return !address.isEmpty()
        }
        
        return false
    }
    
    func getAddress() -> Address? {
        return pinPoint.coordinate.address
    }
}
