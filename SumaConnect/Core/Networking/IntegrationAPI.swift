//
//  IntegrationAPI.swift
//  SumaConnect
//
//  Created by Alberto Orrantia on 08/12/25.
//

import Foundation

enum IntegrationAPI {
    // Local Vapor backend
    
    // Low security risk, for development and MVP purposes, having a private LAN IP poses NO external risk as its not publicly routable
    // Development TODO: Please change  to you local IP, please ensure this to be able to connect with physical devices.
    // Trade Off: In production we will use a secure domain such as https://api.example.com
    
    private static let baseURL = "http://192.168.0.40:8080"
    
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
