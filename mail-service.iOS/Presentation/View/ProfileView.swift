//
//  ProfileView.swift
//  mail-service.iOS
//
//  Created by HITSStudent on 24.06.2024.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        VStack {
            if let profile = viewModel.profile {
                Text("Имя: \(profile.name)")
                Text("Фамилия: \(profile.surname)")
                Text("Дата рождения: \(profile.birthday)")
                Text("Пол: \(profile.gender)")
                Text("Логин: \(profile.login)")
                Text("Номер телефона: \(profile.phoneNum ?? "Не указан")")
                if let avatar = profile.avatar, let url = URL(string: avatar) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                }
            } else if let errorMessage = viewModel.errorMessage {
                Text("Ошибка: \(errorMessage)")
                    .foregroundColor(.red)
            } else {
                ProgressView()
            }
        }
        .padding()
        .navigationTitle("Profile")
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
