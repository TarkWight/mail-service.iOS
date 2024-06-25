//
//  SettingsView.swift
//  mail-service.iOS
//
//  Created by HITSStudent on 24.06.2024.
//

import SwiftUI
import Combine

struct SettingsView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var coordinator: Coordinator
    @State private var cancellables = Set<AnyCancellable>()

    private let userUseCase = UserUseCase()

    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                print("Edit Profile tapped")
            }) {
                Text("Редактировать профиль")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            Button(action: {
                logout()
            }) {
                Text("Выйти")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding(16)
        .navigationTitle("Настройки")
    }
    
    private func logout() {
        userUseCase.logout()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Logout request finished")
                case .failure(let error):
                    print("Error during logout: \(error.localizedDescription)")
                }
            }, receiveValue: { _ in
                self.authManager.logout()
                self.coordinator.replace(with: .authorization)
            })
            .store(in: &cancellables)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(AuthManager())
            .environmentObject(Coordinator())
    }
}
