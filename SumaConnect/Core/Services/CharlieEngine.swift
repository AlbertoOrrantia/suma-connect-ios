//
//  CharlieEngine.swift
//  SumaConnect
//
//  Created by Alberto Orrantia on 08/12/25.
//

import Foundation

// For MVP purposes we will simulate Charlie, to be replaced with Gemini or Apple Intelligence
final class CharlieEngine {
    
    // MVP Integrations
    private let supportedIntegrations = [
        "gmail", 
        "google-calendar",
        "google-meet"
    ]
    
    
    // Initial Greeting
    func initialGreeting(for userName: String?) -> String {
        let name = userName?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let name, !name.isEmpty {
            return "Hola \(name) 👋 ¿en qué puedo ayudarte hoy?"
        } else {
            return "Hola 👋 ¿en qué puedo ayudarte hoy?"
        }
    }
    
    //MARK: - Intent Parsing
    func parseIntent(from text: String, pendingIntegrationId: String?) -> CharlieIntent {
        let lower = text.lowercased()
        let actionKeywords = [
            "conecta", "conectar", 
            "agrega", "agregar",
            "vincula", "vincular",
            "enlaza", "enlazar",
            "asocia", "asociar",
            "linkea", "linkear"
        ]
        
        func mentionsAction() -> Bool {
            actionKeywords.contains { lower.contains($0) }
        }
        
        //Confirmation
        if let pending = pendingIntegrationId {
            if lower.contains("si") || lower.contains("sí") {
                return .confirmConnection(pending)
            }
            if lower.contains("no") {
                return .declineConnection(pending)
            }
        }
        
        // For MVP purposes, if integration is mentioned it will assume the users wants to connect it
        if lower.contains("gmail") {
            if mentionsAction() {
                return .connectIntegration("gmail")
            } else {
                return .connectIntegration("gmail")
            }
        }
        
        if lower.contains("calendar") || lower.contains("calendario") {
            if mentionsAction() {
                return .connectIntegration("google-calendar")
            } else {
                return .connectIntegration("google-calendar")
            }
        }
        
        return .unknown
    }
    
    // MARK: - Responses
    func respond(to intent: CharlieIntent) -> String {
        switch intent {
        case .connectIntegration(let id):
            let name = displayName(for: id)
            return "Claro, puedo ayudarte a conectar \(name) ¿Deseas continuar?"
        case .confirmConnection(let id):
            let name = displayName(for: id)
            return "Perfecto, voy a iniciar la conexión con \(name)"
        case .declineConnection(let id):
            let name = displayName(for: id)
            return "Entiendo, por el momento no voy a intentar conectarme a \(name). Puedes reintentarlo cuando quieras"
        case .unknown:
            let readableList = supportedIntegrations
                .map { displayName(for: $0) }
                .joined(separator: ", ")
            return "Lo siento, no logre identificar qué servicio quieres conectar. Aquí tienes algunas opciones: \(readableList)"
        }
    }
    
    // Translate backend Id into readable names
    private func displayName(for id: String) -> String {
        switch id {
        case "gmail":
            return "Gmail"
        case "google-calendar":
            return "Google Calendar"
        case "google-meet":
            return "Google Meet"
        default:
            return id
        }
    }
    
}

// MVP intents for Charlie
enum CharlieIntent {
    case connectIntegration(String)
    case confirmConnection(String)
    case declineConnection(String)
    case unknown
}
