//
//  HomeViewModel.swift
//  SumaConnect
//
//  Created by Alberto Orrantia on 10/12/25.
//

import SwiftUI
import Combine

struct HomeIntegration: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let statusText: String
    let statusColor: Color
}

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var integrations: [HomeIntegration] = []
    @Published var isLoading: Bool = false
    
    // Will simulate fetching data, for MVP we will mock it
    func loadIntegrations() {
        isLoading = true
        
        let mockData: [HomeIntegration] = [
            .init(
                name: "Gmail",
                description: "Conecta tu correo para que Charlie pueda ayudarte con tus emails.",
                statusText: "Conectado",
                statusColor: Color.green
            ),
            .init(
                name: "Google Drive",
                description: "Accede a tus documentos para resumir y buscar información.",
                statusText: "No conectado",
                statusColor: Color.gray
            ),
            .init(
                name: "Calendar",
                description: "Sincroniza tus eventos para organizar tu día con Charlie.",
                statusText: "Pendiente",
                statusColor: Color.orange
            )
        ]
        // Simulate API latency, when connected to a real backend replace this with async/await
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.integrations = mockData
            self.isLoading = false
        }
    }
    
    // TBD refresh tokens and status; implement cache data for slow connecting users
}
