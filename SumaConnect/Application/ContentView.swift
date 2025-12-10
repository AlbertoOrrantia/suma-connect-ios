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
                NavigationStack {
                    HomeView()
                        .navigationBarBackButtonHidden(true)
                }
            } else {
                NavigationStack {
                    LoginView(viewModel: LoginViewModel(session: session))
                        .navigationBarBackButtonHidden(true)
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(SessionViewModel())
}
