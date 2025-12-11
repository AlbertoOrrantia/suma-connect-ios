//
//  MainTabView.swift
//  SumaConnect
//
//  Created by Alberto Orrantia on 11/12/25.
//

import SwiftUI

struct MainTabView: View {
    
    init() {
        let appearance = UITabBarAppearance()
        
        appearance.backgroundEffect = UIBlurEffect(style: .systemChromeMaterial)
        appearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.1)
        
        // Apply this appearance to both static and scrolling states to avoid UI glitches
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
    }
    
    var body: some View {
        TabView {
            // Wraps Home in its own stack so navigation history is preserved per tab
            NavigationStack {
                HomeView()
                    .toolbar(.hidden, for: .navigationBar)
            }
            .tabItem {
                Label("Inicio", systemImage: "square.grid.2x2.fill")
            }
            
            NavigationStack {
                ChatView()
                    .toolbar(.hidden, for: .navigationBar)
            }
            .tabItem {
                Label("Charlie", systemImage: "bubble.left.and.bubble.right.fill")
            }
        }
        .accentColor(Color.Suma.lightBlue)
    }
}

#Preview {
    MainTabView()
        .environmentObject(SessionViewModel(userId:"demo", userName:"Demo User"))
}
