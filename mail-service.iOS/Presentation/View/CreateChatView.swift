//
//  CreateChatView.swift
//  mail-service.iOS
//
//  Created by HITSStudent on 25.06.2024.
//

import SwiftUI

struct CreateChatView: View {
    @ObservedObject var viewModel = ChatViewModel()
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        VStack {
            TextField("Theme (optional)", text: $viewModel.createChatModel.theme)
                .padding()
                .border(Color.gray)
            
            TextField("Body", text: $viewModel.createChatModel.body)
                .padding()
                .border(Color.gray)

            TextField("Receiver", text: $viewModel.createChatModel.receiver)
                .padding()
                .border(Color.gray)
            
            Button(action: {
                viewModel.createChat()
                coordinator.pop()
            }) {
                Text("Create Chat")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        .padding()
        .navigationTitle("Чаты")
    }
}

struct CreateChatView_Previews: PreviewProvider {
    static var previews: some View {
        CreateChatView().environmentObject(Coordinator())
    }
}
