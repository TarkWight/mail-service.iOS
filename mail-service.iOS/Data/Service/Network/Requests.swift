//
//  Requests.swift
//  mail-service.iOS
//
//  Created by HITSStudent on 23.06.2024.
//

import Foundation

struct RegistrationRequest: Encodable {
    let name: String
    let surname: String
    let birthday: String
    let gender: String
    let mail: String
    let phoneNum: String
    let password: String
}

struct LoginRequest: Encodable {
    let email: String
    let password: String
}
