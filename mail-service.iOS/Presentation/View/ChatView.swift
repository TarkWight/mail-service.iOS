//
//  ChatView.swift
//  mail-service.iOS
//
//  Created by HITSStudent on 25.06.2024.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var viewModel = ChatViewModel()
    @EnvironmentObject var coordinator: Coordinator

    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.chats) { chat in
                    Text(chat.email)
                        .onTapGesture {
                            print("Chat tapped: \(chat.email)")
                        }
                }

                Spacer()

                HStack {
                    Spacer()

                    Button(action: {
                        coordinator.push(.createChat)
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    .padding()
                }
            }
            .navigationBarTitle("Chats")
            .onAppear {
                viewModel.fetchChats()
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView().environmentObject(Coordinator())
    }
}
