//
//  ChatViewModel.swift
//  mail-service.iOS
//
//  Created by HITSStudent on 25.06.2024.
//

import Combine

class ChatViewModel: ObservableObject {
    @Published var chats: [getChat] = []
    @Published var errorMessage: String?
    @Published var createChatModel = CreateChatModel()
    private let chatService = ChatUseCase()
    private var cancellables = Set<AnyCancellable>()

    init() {
        fetchChats()
    }

    func fetchChats() {
        print("try to fetch chat")
        chatService.fetchChats()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Chat fetch successfully")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("Fail to fetch chat - \(error)")
                }
            }, receiveValue: { chats in
                self.chats = chats
            })
            .store(in: &cancellables)
    }
    
    func createChat() {
        print("try to create chat")
        chatService.createChat(chat: createChatModel)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Chat created successfully.")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print(error)
                }
            }, receiveValue: {
                self.fetchChats()
            })
            .store(in: &cancellables)
    }
}
