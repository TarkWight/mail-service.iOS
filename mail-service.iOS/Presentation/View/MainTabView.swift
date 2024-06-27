//
//  MainTabView.swift
//  mail-service.iOS
//
//  Created by HITSStudent on 24.06.2024.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
                .tag(0)
            
            ChatView()
                .tabItem {
                    Image(systemName: "message")
                    Text("Chats")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
                .tag(2)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
