//
//  ThemesViewModel.swift
//  mail-service.iOS
//
//  Created by HITSStudent on 27.06.2024.
//

import Combine

class ThemesViewModel: ObservableObject {
    @Published var themes: [String] = []
    @Published var errorMessage: String?
    private let chatService = ChatUseCase()
    private var cancellables = Set<AnyCancellable>()
    let interlocutor: String
    
    init(interlocutor: String) {
        self.interlocutor = interlocutor
        fetchThemes()
    }

    func fetchThemes() {
        print("try to fetch themes for \(interlocutor)")
        chatService.fetchThemes(interlocutor: interlocutor)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Themes fetched successfully")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("Fail to fetch themes - \(error)")
                }
            }, receiveValue: { themes in
                self.themes = themes
                if themes.isEmpty {
                    self.themes = ["default"]
                }
            })
            .store(in: &cancellables)
    }
}
