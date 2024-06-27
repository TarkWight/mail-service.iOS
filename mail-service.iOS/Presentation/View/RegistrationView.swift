//
//  RegistrationView.swift
//  mail-service.iOS
//
//  Created by HITSStudent on 23.06.2024.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject private var viewModel = RegistrationViewModel()
    @StateObject private var authManager = AuthManager()
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("Имя", text: $viewModel.userRegistrationModel.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Фамилия", text: $viewModel.userRegistrationModel.surname)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Дата рождения (31-01-2000)", text: $viewModel.userRegistrationModel.birthday)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Пол (М или Ж)", text: $viewModel.userRegistrationModel.gender)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Логин", text: $viewModel.userRegistrationModel.login)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Номер телефона", text: $viewModel.userRegistrationModel.phoneNum)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Пароль", text: $viewModel.userRegistrationModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                viewModel.register()
            }) {
                Text("Регистрация")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top, 20)
            
            if viewModel.isAuthenticated {
                Text("Регистрация успешна!")
                    .foregroundColor(.green)
                    .padding(.top, 20)
            }
            
        }
        .padding(16)
        .navigationTitle("Регистрация")
        .navigationBarBackButtonHidden(true)
        .onReceive(viewModel.$isAuthenticated) { isAuthenticated in
            if isAuthenticated {
                self.authManager.auth()
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
