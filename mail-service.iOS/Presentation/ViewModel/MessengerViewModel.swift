//
//  MessagesViewModel.swift
//  mail-service.iOS
//
//  Created by HITSStudent on 27.06.2024.
//

import Foundation
import Combine

class MessagesViewModel: ObservableObject {
    @Published var messages: [Message]? = nil
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false

    private var cancellables = Set<AnyCancellable>()
    private let interlocutor: String
    private let theme: String

    init(interlocutor: String, theme: String) {
        self.interlocutor = interlocutor
        self.theme = theme
    }

    func fetchMessages() {
        guard let url = URL(string: "http://etbx.ru:7070/get_messages_by_theme/\(interlocutor)/\(theme)") else {
            self.errorMessage = "Invalid URL"
            return
        }

        isLoading = true

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: MessagesResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in
                self.messages = response.messages
            }
            .store(in: &cancellables)
    }
}

struct MessagesResponse: Codable {
    let messages: [Message]
}

struct Message: Codable, Identifiable {
    let id: String
    let subject: String
    let body: String
    let sender: String
    let recipient: String
    let receivedTime: String
    let files: [String]

    enum CodingKeys: String, CodingKey {
        case id, subject, body, sender, recipient, receivedTime = "received_time", files = "Файлы"
    }
}
