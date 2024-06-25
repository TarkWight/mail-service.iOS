//
//  AuthManager.swift
//  mail-service.iOS
//
//  Created by HITSStudent on 23.06.2024.
//

import Foundation
import Combine

final class AuthManager: ObservableObject {
    var cancellables = Set<AnyCancellable>()
    private let authKey = "isAuthenticated"
    
    @Published var isAuthenticated: Bool {
        didSet {
            saveAuthState()
        }
    }

    init() {
        self.isAuthenticated = UserDefaults.standard.bool(forKey: authKey)
    }

    func auth() {
        isAuthenticated = true
    }

    func logout() {
        isAuthenticated = false
    }

    private func saveAuthState() {
        UserDefaults.standard.set(isAuthenticated, forKey: authKey)
        if UserDefaults.standard.synchronize() {
            print("Saved auth state successfully. Status is \(isAuthenticated)")
        } else {
            print("Failed to save auth state")
        }
    }
}
