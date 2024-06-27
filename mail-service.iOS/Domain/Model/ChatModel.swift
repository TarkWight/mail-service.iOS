//
//  ChatModel.swift
//  mail-service.iOS
//
//  Created by HITSStudent on 25.06.2024.
//

import Foundation

struct getChat: Identifiable, Decodable {
    var id: Int
    var email: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case email
    }
}

struct CreateChatModel {
    var theme: String = ""
    var body: String = ""
    var receiver: String = ""
}
