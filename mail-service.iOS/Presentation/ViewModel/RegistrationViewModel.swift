//
//  RegistrationViewModel.swift
//  mail-service.iOS
//
//  Created by HITSStudent on 23.06.2024.
//

import SwiftUI
import Combine

final class RegistrationViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var userRegistrationModel = UserRegistrationModel()
    @Published var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()
    private let userUseCase = UserUseCase()

    func register() {
        userUseCase.register(user: userRegistrationModel)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Registration failed: \(error)")
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { token in
                NetworkService.shared.setToken(token)
                self.isAuthenticated = true
                self.errorMessage = nil
            })
            .store(in: &cancellables)
    }
}
