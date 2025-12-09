//
//  IntegrationService.swift
//  SumaConnect
//
//  Created by Alberto Orrantia on 08/12/25.
//

import Foundation

// Service layer, wraps IntegrationAPI + NetworkClient
final class IntegrationService {
    private let client: NetworkClient
    
    init(client: NetworkClient = .shared) {
        self.client = client
    }
    
    // MARK: - Catalog
    func fetchCatalog() async throws -> [Integration] {
        try await client.request(IntegrationAPI.catalogURL, method: .get)
    }
    
    // MARK: - User Integrations
    func fetchUserIntegrations(userId: String) async throws -> [UserIntegration] {
        try await client.request(IntegrationAPI.userIntegrationsURL(userId: userId), method: .get)
    }
    
    func startConnection(userId: String, integrationId: String) async throws -> String {
        struct StartResponse: Decodable {
            let authUrl: String
        }
        
        let response: StartResponse = try await client.request(IntegrationAPI.startConnectionURL(userId: userId, integrationId: integrationId), method: .post)
        return response.authUrl
    }
    
    func completeConnection(userId: String, integrationId: String, success: Bool) async throws -> [UserIntegration] {
        let body = IntegrationAPI.CompleteRequest(success: success)
        
        return try await client.request(IntegrationAPI.completeConnectionURL(userId: userId, integrationId: integrationId), method: .post, body: body)
    }
    
    func disconnect(userId: String, integrationId: String) async throws -> [UserIntegration] {
        try await client.request(IntegrationAPI.disconnectURL(userId: userId, integrationId: integrationId), method: .post)
    }
}
