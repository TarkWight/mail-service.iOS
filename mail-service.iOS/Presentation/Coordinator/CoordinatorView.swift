//
//  CoordinatorView.swift
//  mail-service.iOS
//
//  Created by HITSStudent on 23.06.2024.
//

import SwiftUI

struct CoordinatorView: View {
    @StateObject private var coordinator = Coordinator()
    @StateObject private var authManager = AuthManager()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: pageSelector())
                .navigationDestination(for: Page.self) { page in
                    coordinator.build(page: page)
                }
        }
        .environmentObject(coordinator)
    }
    
    private func pageSelector() -> Page {
        print(authManager.isAuthenticated)
        return authManager.isAuthenticated ? .tabBar : .authorization
    }
}

struct CoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        CoordinatorView()
    }
}
