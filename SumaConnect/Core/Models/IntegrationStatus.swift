//
//  IntegrationStatus.swift
//  SumaConnect
//
//  Created by Alberto Orrantia on 07/12/25.
//

import Foundation

enum IntegrationStatus: String, Codable {
    case disconnected
    case pending
    case connected
    case error
}
