//
//  LoginViewModel.swift
//  SumaConnect
//
//  Created by Alberto Orrantia on 09/12/25.
//

import Foundation
import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    
    // Simple validation for the login button, if no email and password are available, it will not let the user click
    var canSubmit: Bool {
        email.isValidEmail && !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private let session: SessionViewModel
    init(session: SessionViewModel) {
        self.session = session
    }
    
    func login() async {
        guard email.isValidEmail else {
            errorMessage = "Ingresa un correo válido"
            return
        }
        isLoading =  true
        errorMessage = nil
        
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let cleanPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Simulated API response latency of 1 sec, will help for animations
        try? await Task.sleep(for: .seconds(1))
        
        // For MVP purposes we will have hardcoded credentials
        if cleanEmail == "demo@suma.com" && cleanPassword == "password" {
            session.startSession(userId: "demo", userName: "Demo User")
        } else {
            errorMessage = "Credenciales inválidas"
        }
        isLoading = false
        
    }
}

// Simple validation, email must contain @ and an allowed domain
// Fixed allowed domains for MVP
private extension String {
    var isValidEmail: Bool {
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.contains( "@" ) else {
            return false
        }
        
        let parts = trimmed.lowercased().split(separator: "@")
        guard parts.count == 2 else {
            return false
        }
        
        let allowedDomains = ["gmail.com", "outlook.com", "hotmail.com", "suma.com"]
        return  allowedDomains.contains(String(parts[1]))
    }
}
