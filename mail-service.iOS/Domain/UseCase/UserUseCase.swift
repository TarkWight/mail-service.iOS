//
//  UserUseCase.swift
//  mail-service.iOS
//
//  Created by HITSStudent on 23.06.2024.
//

import Combine

final class UserUseCase {
    private var cancellables = Set<AnyCancellable>()
    
    func register(user: UserRegistrationModel) -> AnyPublisher<String, Error> {
        return NetworkService.shared.register(user: user)
            .eraseToAnyPublisher()
    }

    func login(user: UserAuthorizationModel) -> AnyPublisher<String, Error> {
        return NetworkService.shared.login(user: user)
               .eraseToAnyPublisher()
       }
}
