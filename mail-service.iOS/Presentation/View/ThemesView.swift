//
//  ThemesView.swift
//  mail-service.iOS
//
//  Created by HITSStudent on 27.06.2024.
//

import SwiftUI

struct ThemesView: View {
    @EnvironmentObject var viewModel: ThemesViewModel
    @EnvironmentObject var coordinator: Coordinator

    var body: some View {
        List(viewModel.themes, id: \.self) { theme in
            Button(action: {
                let messagesViewModel = MessagesViewModel(interlocutor: viewModel.interlocutor, theme: theme)
                coordinator.inject(viewModel: messagesViewModel)
                coordinator.push(.messages)
            }) {
                Text(theme)
            }
        }
        .navigationTitle("Themes")
        .onAppear {
            viewModel.fetchThemes()
        }
    }
}

struct ThemesView_Previews: PreviewProvider {
    static var previews: some View {
        ThemesView().environmentObject(ThemesViewModel(interlocutor: "test@example.com"))
    }
}
