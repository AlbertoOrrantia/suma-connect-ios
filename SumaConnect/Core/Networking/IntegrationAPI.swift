//
//  IntegrationAPI.swift
//  SumaConnect
//
//  Created by Alberto Orrantia on 08/12/25.
//

import Foundation

enum IntegrationAPI {
    // Local Vapor backend
    private static let baseURL = "http://127.0.0.1:8080"
    
    // MARK: - Endpoints
    
    static var catalogURL: String {
        "\(baseURL)/integrations"
    }
    
    static func userIntegrationsURL(userId: String) -> String {
        "\(baseURL)/users/\(userId)/integrations"
    }
    
    static func startConnectionURL(userId: String, integrationId: String) -> String {
        "\(baseURL)/users/\(userId)/integrations/\(integrationId)/start"
    }
    
    static func completeConnectionURL(userId: String, integrationId: String) -> String {
        "\(baseURL)/users/\(userId)/integrations/\(integrationId)/complete"
    }
    
    static func disconnectURL(userId: String, integrationId: String) -> String {
        "\(baseURL)/users/\(userId)/integrations/\(integrationId)/disconnect"
    }
    
    // MARK: - Request DTOs
    // Body sent when a connection attempt is finalized
    
    struct CompleteRequest: Encodable {
        let success: Bool
    }
}
