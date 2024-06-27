//
//  ChatUseCase.swift
//  mail-service.iOS
//
//  Created by HITSStudent on 27.06.2024.
//

import Alamofire
import Combine

final class ChatUseCase {
//    private var cancellables = Set<AnyCancellable>()
    private let networkService = NetworkService.shared
    
    func fetchChats() -> AnyPublisher<[getChat], AFError> {
        networkService.fetchChats()
    }

    func createChat(chat: CreateChatModel) -> AnyPublisher<Void, AFError> {
        let parameters = CreateChatRequest(theme: chat.theme, body: chat.body, receiver: chat.receiver)
        return networkService.createChat(parameters: parameters)
    }
    
    func fetchThemes(interlocutor: String) -> AnyPublisher<[String], AFError> {
           networkService.fetchThemes(interlocutor: interlocutor)
       }
}

