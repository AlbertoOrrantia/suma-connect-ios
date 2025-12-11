//
//  HomeViewModel.swift
//  SumaConnect
//
//  Created by Alberto Orrantia on 10/12/25.
//

import SwiftUI
import Combine

struct HomeIntegration: Identifiable {
    let id: String
    let name: String
    let description: String
    let statusText: String
    let statusColor: Color
}

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var integrations: [HomeIntegration] = []
    @Published var isLoading: Bool = false
    
    // Connected to Vapor, real dependency
    private let service = IntegrationService()
    
    init() {
        // Observer refreshes data when charlie completes a connection
        NotificationCenter.default.addObserver(self, selector: #selector(forceRefresh), name: NSNotification.Name("RefreshHome"), object: nil)
    }
    
    @objc func forceRefresh() {
        Task { await loadIntegrations() }
    }
    
    func loadIntegrations() async {
        isLoading = true
        
        do {
            // Hardcoded "demo" id for MVP & demo
            let userIntegrations = try await service.fetchUserIntegrations(userId: "demo")
            self.integrations = userIntegrations.map { userInt in
                
                let (statusText, color) = mapStatus(userInt.status)
                let (name, desc) = mapMetadata(id: userInt.integrationId)
                
                return HomeIntegration(
                    id: userInt.integrationId,
                    name: name,
                    description: desc,
                    statusText: statusText,
                    statusColor: color
                )
            }
        } catch {
            print("Error loading Home: \(error.localizedDescription)")
            // TBD Error Handling
        }
        
        isLoading = false
    }

    private func mapStatus(_ status: IntegrationStatus) -> (String, Color) {
        switch status {
        case .connected: return ("Conectado", .green)
        case .pending: return ("Pendiente", .orange)
        case .disconnected: return ("Conectar", .gray)
        case .error: return ("Error", .red)
        }
    }
    
    private func mapMetadata(id: String) -> (String, String) {
        // Static catalog, will refactor further MVP
        switch id {
        case "gmail":
            return ("Gmail", "Conecta tu correo para que Charlie pueda ayudarte con tus emails.")
        case "google-calendar":
            return ("Google Calendar", "Sincroniza tus eventos para organizar tu día.")
        case "google-meet":
            return ("Google Meet", "Gestiona tus videollamadas y reuniones.")
        case "outlook":
            return ("Outlook", "Sincroniza tus correos de Microsoft.")
        default:
            return (id.capitalized, "Integración disponible.")
        }
    }
}
