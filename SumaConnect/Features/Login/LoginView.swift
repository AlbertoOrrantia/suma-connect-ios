//
//  LoginView.swift
//  SumaConnect
//
//  Created by Alberto Orrantia on 09/12/25.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    @State private var showPassword = false
    
    var body: some View {
        ZStack {
            Color.Suma.darkGray
                .ignoresSafeArea()
            
            VStack(spacing: 28) {
                HStack {
                    Spacer()
                    Button {
                        // For MVP purposes, this will only be a placeholder,
                        // sing in functionality will only be available. Sign Up flow TBD
                        print("Crear cuenta tapped")
                    } label: {
                        Text("Crear cuenta")
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(Color.Suma.red)
                            .underline(true)
                    }
                    .padding(.trailing, 20)
                    .padding(.top, 50)
                }
                
                Spacer(minLength: 4)
                
                // Placeholder Logo, MVP will only include title
                SumaTitle(fontSize: 44, style: .stacked)
                    .padding(.top, 50)
                
                // MARK: - Input Fields
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Correo electrónico")
                            .foregroundColor(Color.Suma.darkBlue)
                            .font(.subheadline)
                            .padding(.leading, 5)
                        
                        TextField(
                            "",
                            text: $viewModel.email,
                            prompt: Text("tucorreo@ejemplo.com")
                                .foregroundColor(Color.Suma.darkGray.opacity(0.45))
                        )
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .sumaInputStyle(hasError: viewModel.errorMessage != nil)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Contraseña")
                            .foregroundColor(Color.Suma.darkBlue)
                            .font(.subheadline)
                            .padding(.leading, 5)
                        
                        ZStack(alignment: .trailing) {
                            Group {
                                if showPassword {
                                    TextField(
                                        "",
                                        text: $viewModel.password,
                                        prompt: Text("*********")
                                            .foregroundColor(Color.Suma.darkBlue.opacity(0.45))
                                    )
                                } else {
                                    SecureField(
                                        "",
                                        text: $viewModel.password,
                                        prompt: Text("*********")
                                            .foregroundColor(Color.Suma.darkBlue.opacity(0.45))
                                    )
                                }
                            }
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .sumaInputStyle(hasError: viewModel.errorMessage != nil)
                            
                            Button { showPassword.toggle() } label: {
                                Image(systemName: showPassword ? "eye" : "eye.slash")
                                    .foregroundColor(Color.Suma.darkBlue)
                            }
                            .padding(.trailing, 16)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 40)
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(Color.Suma.errorRed)
                        .font(.footnote)
                        .padding(.top, -8)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
                
                Spacer()
                
                // MARK: - Login button
                VStack(spacing: 22) {
                    Button {
                        UIApplication.shared.sendAction(
                            #selector(UIResponder.resignFirstResponder),
                            to: nil,
                            from: nil,
                            for: nil
                        )
                        Task { await viewModel.login() }
                    } label: {
                        ZStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(Color.black)
                            } else {
                                Text("Iniciar sesión")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .minimumScaleFactor(0.8)
                            }
                        }
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(
                            viewModel.canSubmit
                            ? Color.Suma.red
                            : Color.Suma.red.opacity(0.4)
                        )
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(Color.Suma.darkBlue, lineWidth: 2)
                        )
                        
                    }
                    .disabled(!viewModel.canSubmit || viewModel.isLoading)
                    .opacity(viewModel.canSubmit ? 1 : 0.6)
                    
                    // MARK: - Social Login Buttons
                    // As per MVP these is only a place holder, no action supported

                    HStack(spacing: 16) {
                        SocialButton(
                            text: "Apple",
                            iconName: "applelogo",
                            isSystemImage: true
                        ) {
                            print("Apple login tapped")
                        }
                        
                        SocialButton(
                            text: "Google",
                            iconName: "google",
                            isSystemImage: false
                        ) {
                            print("Google login tapped")
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 60)
            }
        }
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel(session: SessionViewModel()))
}

// Input ViewModifier; for MVP purposes it will be residing here, componetiztion and modularization will be polished after MVP
struct SumaInputStyle: ViewModifier {
    let hasError: Bool
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 15))
            .foregroundColor(Color.Suma.darkBlue)
            .tint(Color.Suma.darkBlue)
            .padding()
            .frame(minHeight: 48)
            .background(Color.Suma.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(hasError ? Color.Suma.errorRed : Color.Suma.darkBlue.opacity(0.35), lineWidth: 1)
            )
    }
}

extension View {
    func sumaInputStyle(hasError: Bool = false) -> some View {
        modifier(SumaInputStyle(hasError: hasError))
    }
}
