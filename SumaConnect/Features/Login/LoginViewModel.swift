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
    
    // Dependencies
    private let integrationService = IntegrationService()
    
    // Simple validation for the login button, if no email and password are available, it will not let the user click
    var canSubmit: Bool {
        email.isValidEmail && !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    init() {}
    
    func login(with session: SessionViewModel) async {
        guard email.isValidEmail else {
            errorMessage = "Ingresa un correo válido"
            return
        }
        isLoading =  true
        errorMessage = nil
        
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let cleanPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // For MVP purposes we will have hardcoded credentials
        if cleanEmail == "demo@suma.com" && cleanPassword == "password" {
            
            // SMOKE TEST: Verify backend connectivity before granting session
            do {
                let userId = "demo"
                let userName = "Demo User"
                
                // Call backend to fetch user data (serving as a connectivity check)
                _ = try await integrationService.fetchUserIntegrations(userId: userId)
                
                // Login Success
                session.startSession(userId: userId, userName: userName)
                
            } catch {
                print("Login Error: \(error)")
                errorMessage = "No se pudo conectar con el servidor. Verifica que el backend esté corriendo."
            }
            
        } else {
            // Failure path retains a small delay for UX
            try? await Task.sleep(for: .seconds(1))
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
        return allowedDomains.contains(String(parts[1]))
    }
}
