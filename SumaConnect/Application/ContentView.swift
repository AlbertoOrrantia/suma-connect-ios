//
//  ContentView.swift
//  SumaConnect
//
//  Created by Alberto Orrantia on 07/12/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var session: SessionViewModel
    var body: some View {
        Group {
            if session.isAuthenticated {
                MainTabView()
                    .transition(.opacity)

            } else {
                LoginView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: session.isAuthenticated)
    }
}

#Preview {
    ContentView()
        .environmentObject(SessionViewModel())
}
