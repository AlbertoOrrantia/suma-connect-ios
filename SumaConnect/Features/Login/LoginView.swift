//
//  LoginView.swift
//  SumaConnect
//
//  Created by Alberto Orrantia on 09/12/25.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        VStack {
            Text("Login")
                .font(.largeTitle)
                .padding()
        }
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel(session: SessionViewModel()))
}
