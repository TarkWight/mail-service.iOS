//
//  Coordinator.swift
//  mail-service.iOS
//
//  Created by HITSStudent on 23.06.2024.
//

import SwiftUI

protocol CoordinatorProtocol {
    func push(_ page: Page)
    
    func pop()
    
    func popToRoot()
    
    func present(fullScreenCover: FullScreenCover)
}

enum Page: String, Identifiable {
    case registration, authorization
    
    var id: String {
        self.rawValue
    }
}

enum Sheet: String, Identifiable {
    case mock
    
    var id: String {
        self.rawValue
    }
}

enum FullScreenCover: String, Identifiable {
    case mock
    
    var id: String {
        self.rawValue
    }
}

class Coordinator: ObservableObject, CoordinatorProtocol {
    @Published var path = NavigationPath()
    @Published var fullScreenCover: FullScreenCover?
    
    func push(_ page: Page) {
        path.append(page)
    }
    
    func replace(with page: Page) {
        path = NavigationPath()
        path.append(page)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func present(fullScreenCover: FullScreenCover) {
        self.fullScreenCover = fullScreenCover
    }
    
    @ViewBuilder
    func build(page: Page) -> some View {
        switch page {
        case .registration:
            RegistrationView()
        case .authorization:
            AuthorizationView()
        }
    }
}
