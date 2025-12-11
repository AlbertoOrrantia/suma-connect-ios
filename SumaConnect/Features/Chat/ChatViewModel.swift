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
    private enum PendingAction { case connect, disconnect }
    private var pendingActionType: PendingAction = .connect
    
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
                self.pendingActionType = .connect
                responseText = engine.respond(to: intent)
                
            case .disconnectIntegration(let id):
                // Simetría: Guarda ID y acción, y el Engine pide confirmación.
                self.pendingIntegrationId = id
                self.pendingActionType = .disconnect
                responseText = engine.respond(to: intent)
                
            case .confirmConnection(let id):
                self.pendingIntegrationId = nil
                
                // Decisión: Ejecutamos la acción pendiente
                if pendingActionType == .disconnect {
                    responseText = await performDisconnection(for: id)
                } else {
                    responseText = await initiateConnectionSequence(for: id)
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
    
    // MARK: - Connection Workflow & Simulation
    
    private func initiateConnectionSequence(for integrationId: String) async -> String {
        do {
            print("Chat VM init: \(integrationId)")
            
            let authUrl = try await integrationService.startConnection(userId: "demo", integrationId: integrationId)
            
            simulateExternalAuthorization(for: integrationId)
            
            return "¡Listo! He iniciado la conexión. Por favor autoriza el acceso [haciendo click aquí](\(authUrl))."
            
        } catch {
            print("Chat VM startConnection error: \(error)")
            return "Tuve un problema contactando al servidor. Por favor intenta más tarde."
        }
    }
    
    private func simulateExternalAuthorization(for integrationId: String) {
        Task {
            try? await Task.sleep(for: .seconds(3))
            
            do {
                print("ChatVM Id: \(integrationId)")
                
                _ = try await integrationService.completeConnection(userId: "demo", integrationId: integrationId, success: true)
                
                let successMessage = ChatMessage(
                    text: "¡Excelente! He detectado que la autorización fue exitosa. \(integrationId.capitalized) ya está conectado.",
                    sender: .charlie,
                    createdAt: Date()
                )
                
                await MainActor.run {
                    withAnimation { self.messages.append(successMessage) }
                    print("ChatVM sending notification")
                    NotificationCenter.default.post(name: NSNotification.Name("RefreshHome"), object: nil)
                }
            } catch {
                print("ChatVM Error: \(error)")
            }
        }
    }
    
    // MARK: - Disconnection Logic
    private func performDisconnection(for integrationId: String) async -> String {
        do {
            // Execute API disconnection call
            _ = try await integrationService.disconnect(userId: "demo", integrationId: integrationId)
            
            // Trigger home refresh
            await MainActor.run {
                NotificationCenter.default.post(name: NSNotification.Name("RefreshHome"), object: nil)
            }
            return "Listo. He desconectado \(integrationId.capitalized) de tu cuenta."
        } catch {
            return "Tuve un problema intentando desconectar el servicio. Intenta más tarde."
        }
    }
}
