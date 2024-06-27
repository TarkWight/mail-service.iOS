//
//  CacheService.swift
//  mail-service.iOS
//
//  Created by HITSStudent on 27.06.2024.
//

import Foundation

class CacheService {
    private var messagesCache: [String: [Message]] = [:]

    func saveMessages(_ messages: [Message], forKey key: String) {
        messagesCache[key] = messages
    }

    func loadMessages(forKey key: String) -> [Message]? {
        return messagesCache[key]
    }
}
