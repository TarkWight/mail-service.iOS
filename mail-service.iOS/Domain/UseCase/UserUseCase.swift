//
//  UserUseCase.swift
//  mail-service.iOS
//
//  Created by HITSStudent on 23.06.2024.
//

import Combine
import Alamofire

final class UserUseCase {
    private var cancellables = Set<AnyCancellable>()
    private let networkService = NetworkService.shared
    
    func register(user: UserRegistrationModel) -> AnyPublisher<String, Error> {
        networkService.register(user: user)
            .eraseToAnyPublisher()
    }

    func login(user: UserAuthorizationModel) -> AnyPublisher<String, Error> {
        networkService.login(user: user)
            .eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Void, Error> {
        networkService.logout()
            .eraseToAnyPublisher()
    }
    
    func fetchUserProfile() -> AnyPublisher<UserProfile, AFError> {
            networkService.fetchUserProfile()
                .eraseToAnyPublisher()
        }
}

