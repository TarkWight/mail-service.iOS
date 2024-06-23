//
//  mainApplication.swift
//  mail-service.iOS
//
//  Created by Tark Wight on 19.06.2024.
//

import SwiftUI

@main
struct mainApplication: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            RegistrationView()
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
