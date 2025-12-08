//
//  UserIntegration.swift
//  SumaConnect
//
//  Created by Alberto Orrantia on 07/12/25.
//

import Foundation

// Stores users current status for an integration
struct UserIntegration: Codable, Identifiable {
    let userId: String
    let integrationId: String
    var status: IntegrationStatus
    
    //Unique Id, combines user & integrationid
    var id: String {
        "\(userId)|\(integrationId)"
    }
}
