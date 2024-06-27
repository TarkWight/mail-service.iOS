//
//  AuthorizationView.swift
//  mail-service.iOS
//
//  Created by HITSStudent on 23.06.2024.
//

import SwiftUI
import Combine

struct AuthorizationView: View {
    @StateObject private var viewModel = AuthorizationViewModel()
    @StateObject private var authManager = AuthManager()
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("Электронная почта", text: $viewModel.userAuthorizationModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
            SecureField("Пароль", text: $viewModel.userAuthorizationModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                viewModel.login()
            }) {
                Text("Войти")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top, 20)
            
            if viewModel.isAuthenticated {
                Text("Вход выполнен успешно!")
                    .foregroundColor(.green)
                    .padding(.top, 20)
                    .onAppear {
                        self.authManager.auth()
                        coordinator.replace(with: .tabBar)
                    }
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text("Ошибка: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding(.top, 20)
            }
            
            HStack {
                Text("Нет аккаунта?")
                Button(action: {
                    coordinator.replace(with: .registration)
                    
                }) {
                    Text("Создать")
                        .foregroundColor(.blue)
                }
            }
            .padding(.top, 10)
        }
        .padding(16)
        .navigationTitle("Вход")
        .navigationBarBackButtonHidden(true)
        .onReceive(viewModel.$isAuthenticated) { isAuthenticated in
            if isAuthenticated {
                self.authManager.auth()
            }
        }
    }
}

struct AuthorizationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorizationView()
    }
}
