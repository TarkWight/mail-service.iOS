//
//  MessengerView.swift
//  mail-service.iOS
//
//  Created by HITSStudent on 27.06.2024.
//

//
//  MessagesView.swift
//  mail-service.iOS
//
//  Created by HITSStudent on 27.06.2024.
//

import SwiftUI

struct MessagesView: View {
    @ObservedObject var viewModel: MessagesViewModel

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading messages...")
            } else if let messages = viewModel.messages {
                List(messages) { message in
                    VStack(alignment: .leading) {
                        Text("От: \(message.sender)")
                            .font(.headline)
                        Text("Кому: \(message.recipient)")
                            .font(.subheadline)
                        Text("Время: \(message.receivedTime)")
                            .font(.caption)
                        Text("Сообщение: \(message.body)")
                            .padding(.top, 2)
                        if !message.files.isEmpty {
                            Text("Файлы:")
                                .font(.subheadline)
                            ForEach(message.files, id: \.self) { file in
                                Text(file)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .navigationTitle("Messages")
        .onAppear {
            viewModel.fetchMessages()
        }
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView(viewModel: MessagesViewModel(interlocutor: "test@example.com", theme: "Тема 1"))
    }
}
