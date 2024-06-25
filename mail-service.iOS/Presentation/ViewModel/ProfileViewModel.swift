//
//  ProfileViewModel.swift
//  mail-service.iOS
//
//  Created by HITSStudent on 24.06.2024.
//

import Combine

class ProfileViewModel: ObservableObject {
    @Published var profile: UserProfile?
    @Published var errorMessage: String?

    private let userUseCase = UserUseCase()
    private var cancellables = Set<AnyCancellable>()

    init() {
        fetchUserProfile()
    }

    func fetchUserProfile() {
        if let storedProfile = CoreDataService.shared.fetchUserProfile() {
            self.profile = storedProfile
            print("Fetched user profile from local storage")
        } else {
            userUseCase.fetchUserProfile()
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    }
                }, receiveValue: { userProfile in
                    self.profile = userProfile
                    CoreDataService.shared.saveUserProfile(userProfile)
                })
                .store(in: &cancellables)
        }
    }
}
