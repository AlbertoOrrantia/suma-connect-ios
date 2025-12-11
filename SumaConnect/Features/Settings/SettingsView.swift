//
//  SettingsView.swift
//  SumaConnect
//
//  Created by Alberto Orrantia on 11/12/25.
//

import SwiftUI

// Post MVP TODO: Implement Dark Mode (via colorScheme) and Language selection
struct SettingsView: View {
    @EnvironmentObject var session: SessionViewModel
    
    // Legal requirement for apps, for MVP we will use simple web page as a simulation
    private let termsURL = URL(string: "https://www.lipsum.com/")!
    private let privacyURL = URL(string: "https://www.lipsum.com/")!

    var body: some View {
        ZStack {
            Color.Suma.darkGray
                .ignoresSafeArea()

            VStack(spacing: 0) {
                SumaHeaderView()
                
                VStack(spacing: 0) {
                    List {
                        // MARK: - Legal Section
                        Section(header: Text("Legal")) {
                            // Terms & Conditions Link
                            Link(destination: termsURL) {
                                HStack {
                                    Label("Términos y Condiciones", systemImage: "doc.text")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            // Privacy Policy Link
                            Link(destination: privacyURL) {
                                HStack {
                                    Label("Política de Privacidad", systemImage: "lock.shield")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                    
                    Spacer()
                    
                    // MARK: - Logout Button
                    // Maitains main design language and style
                    Button {
                        session.logout()
                    } label: {
                        Text("Cerrar Sesión")
                            .font(.headline)
                            .foregroundColor(Color.Suma.white)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color.Suma.errorRed)
                            .clipShape(Capsule())
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
                .navigationTitle("Ajustes")
                .navigationBarTitleDisplayMode(.large)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SessionViewModel(userId: "demo", userName: "Demo User"))
}

