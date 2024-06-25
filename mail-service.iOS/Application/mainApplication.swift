//
//  mainApplication.swift
//  mail-service.iOS
//
//  Created by Tark Wight on 19.06.2024.
//

import SwiftUI

@main
struct mainApplication: App {
    @StateObject private var authManager = AuthManager()
       @StateObject private var coordinator = Coordinator()

      var body: some Scene {
          WindowGroup {
              CoordinatorView()
                  .environmentObject(authManager)
                  .environmentObject(coordinator)
          }
      }
}
