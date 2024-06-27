//
//  SettingsView.swift
//  mail-service.iOS
//
//  Created by HITSStudent on 24.06.2024.
//

import SwiftUI
import Combine

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @EnvironmentObject var authManager: AuthManager
      @EnvironmentObject var coordinator: Coordinator
      @State private var cancellables = Set<AnyCancellable>()
    private let userUseCase = UserUseCase()
    @State private var name: String = ""
    @State private var surname: String = ""
    @State private var birthday: String = ""
    @State private var gender: String = ""
    @State private var phoneNum: String = ""
    @State private var errorMessage: String?
    
    
    var body: some View {
        VStack {
            if let profile = viewModel.profile {
                // Text fields for user input with default values from profile
                TextField("Имя", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onAppear {
                        self.name = profile.name
                    }
                TextField("Фамилия", text: $surname)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onAppear {
                        self.surname = profile.surname
                    }
                TextField("Дата рождения", text: $birthday)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onAppear {
                        self.birthday = profile.birthday
                    }
                TextField("Пол", text: $gender)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onAppear {
                        self.gender = profile.gender
                    }
                TextField("Номер телефона", text: $phoneNum)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onAppear {
                        self.phoneNum = profile.phoneNum ?? ""
                    }
                
                Button(action: {
                    // Action to edit profile
                    viewModel.editProfile(request: EditProfileRequest(
                        name: name.isEmpty ? profile.name : name,
                        surname: surname.isEmpty ? profile.surname : surname,
                        birthday: birthday.isEmpty ? profile.birthday : birthday,
                        gender: gender.isEmpty ? profile.gender : gender,
                        phoneNum: phoneNum.isEmpty ? profile.phoneNum : phoneNum,
                        password: ""
                    ))
                }) {
                    Text("Сохранить изменения")
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(5)
                
                Button(action: {
                    // Action to logout
                    logout()
                    self.coordinator.replace(with: .authorization)

                }) {
                    Text("Выйти")
                }
                .padding()
                .foregroundColor(.red)
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            } else {
                // Placeholder or loading state
                Text("Загрузка профиля...")
            }
        }
        .onAppear {
            // Fetch user profile when view appears
            viewModel.updateUserProfile()
        }
        .navigationBarTitle("Настройки")
    }
    private func logout() {
        userUseCase.logout()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel())
    }
}
