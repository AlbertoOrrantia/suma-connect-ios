//
//  ChatViewModel.swift
//  SumaConnect
//
//  Created by Alberto Orrantia on 11/12/25.
//

import SwiftUI
import Combine

@MainActor
final class ChatViewModel: ObservableObject {
    
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var isTyping: Bool = false
    
    // Real service connected to vapor
    private let engine = CharlieEngine()
    private let integrationService = IntegrationService()
    
    private var pendingIntegrationId: String? = nil
    
    init() {
        let greeting = engine.initialGreeting(for: "Usuario")
        let msg = ChatMessage(
            text: greeting,
            sender: .charlie,
            createdAt: Date()
        )
        messages.append(msg)
    }
    
    // MARK: - Actions
    func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        
        let userMsg = ChatMessage(
            text: text,
            sender: .user,
            createdAt: Date()
        )
        
        withAnimation {
            messages.append(userMsg)
            inputText = ""
        }
        
        isTyping = true
        
        Task {
            // Simulating a real life latency delay
            try? await Task.sleep(for: .seconds(0.8))
            
            let intent = engine.parseIntent(from: text, pendingIntegrationId: pendingIntegrationId)
            var responseText = ""
            
            switch intent {
            case .connectIntegration(let id):
                self.pendingIntegrationId = id
                responseText = engine.respond(to: intent)
                
            case .confirmConnection(let id):
                self.pendingIntegrationId = nil
                
                // Connection to Vapor
                do {
                    let authUrl = try await integrationService.startConnection(userId: "demo", integrationId: id)
                    
                    // Creating the URL hyperlink format
                    responseText = "¡Listo! He iniciado la conexión. Por favor autoriza el acceso [haciendo click aquí](\(authUrl))."
                    
                } catch {
                    print("Error conectando con Vapor: \(error)")
                    // Mensaje de error amigable
                    responseText = "Tuve un problema contactando al servidor. Por favor intenta más tarde."
                }
                
            case .declineConnection:
                self.pendingIntegrationId = nil
                responseText = engine.respond(to: intent)
                
            case .unknown:
                responseText = engine.respond(to: intent)
            }
            
            let charlieMsg = ChatMessage(
                text: responseText,
                sender: .charlie,
                createdAt: Date()
            )
            
            await MainActor.run {
                withAnimation {
                    self.isTyping = false
                    self.messages.append(charlieMsg)
                }
            }
        }
    }
}
