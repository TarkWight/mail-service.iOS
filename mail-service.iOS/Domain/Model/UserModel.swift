//
//  UserModel.swift
//  mail-service.iOS
//
//  Created by HITSStudent on 23.06.2024.
//

import Foundation

struct UserRegistrationModel {
    var name: String = ""
    var surname: String = ""
    var birthday: String = ""
    var gender: String = ""
    var login: String = ""
    var phoneNum: String = ""
    var password: String = ""
}

struct UserAuthorizationModel {
    var email: String = ""
    var password: String = ""
}

struct UserProfile: Identifiable, Decodable {
    let id: Int
    let name: String
    let surname: String
    let birthday: String
    let gender: String
    let login: String
    let phoneNum: String?
    let avatar: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name = "Имя"
        case surname = "Фамилия"
        case birthday = "Дата рождения"
        case gender = "Пол"
        case login = "Логин"
        case phoneNum = "Номер_телефона"
        case avatar = "Аватар"
    }
}
