//
//  ContentView.swift
//  SumaConnect
//
//  Created by Alberto Orrantia on 07/12/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var session = SessionViewModel()
    var body: some View {
        Group {
            if session.isAuthenticated {
                HomeView()
                    .environmentObject(session)
            } else {
                LoginView(viewModel: LoginViewModel(session: session))
            }
        }
    }
}

#Preview {
    ContentView()
}
