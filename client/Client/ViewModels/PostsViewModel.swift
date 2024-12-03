//
//  PostsViewModel.swift
//  client
//
//  Created by Emircan Duman on 03.12.24.
//

import Foundation
import SwiftUI


@Observable
class PostsViewModel: ObservableObject {
    private(set) var pinPoints: [PinPoint] = []
    var isLoading: Bool = false
    var errorMessage: String?
    
    
    func fetchMyPinPoints() async throws {
        pinPoints = []
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedPins: [PinPoint] = try await APIService.shared.get(endpoint: "pinpoints")
            pinPoints.append(contentsOf: fetchedPins)
        } catch {
            if let apiError = error as? APIError {
                self.errorMessage = apiError.localizedDescription
            } else {
                self.errorMessage = error.localizedDescription
            }
        }
        
        isLoading = false
    }
    
    func addMockPinPoint() {
        pinPoints.append(createMock())
        pinPoints.append(createMock())
        pinPoints.append(createMock())
        pinPoints.append(createMock())
        pinPoints.append(createMock())
        pinPoints.append(createMock())

    }
        
    private func createMock() -> PinPoint {
        let duration = Duration(hours: 1, minutes: 30)
        return PinPoint(title: "MockTitle", description: "MockBody", duration: duration, coordinate: .mock(latitude: 52.5624619, longitude: 13.3344790))
    }
}
