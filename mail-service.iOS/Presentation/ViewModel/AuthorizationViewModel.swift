//
//  AuthorizationViewModel.swift
//  mail-service.iOS
//
//  Created by HITSStudent on 23.06.2024.
//

import SwiftUI
import Combine

final class AuthorizationViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var userAuthorizationModel = UserAuthorizationModel()
    @Published var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()
    private let userUseCase = UserUseCase()

    func login() {
        userUseCase.login(user: userAuthorizationModel)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Login failed: \(error)")
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
