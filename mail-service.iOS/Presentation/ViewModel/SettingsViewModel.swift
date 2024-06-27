//
//  SettingsViewModel.swift
//  mail-service.iOS
//
//  Created by HITSStudent on 27.06.2024.
//

// SettingsViewModel.swift

import SwiftUI
import Combine

final class SettingsViewModel: ObservableObject {
    @Published var profile: UserProfile?
    @Published var errorMessage: String?

    private let userUseCase = UserUseCase()
    private var cancellables = Set<AnyCancellable>()

    init() {
        updateUserProfile()
    }

    func updateUserProfile() {
           if let storedProfile = CoreDataService.shared.fetchUserProfile() {
               self.profile = storedProfile
               print("Fetched user profile from local storage")
           } else {
               print("Not found user profile from local storage")
           }
       }
    func editProfile(request: EditProfileRequest) {
        userUseCase.editProfile(request: request)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Edit profile request finished.")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: {
                // Optionally handle success
            })
            .store(in: &cancellables)
    }
}
