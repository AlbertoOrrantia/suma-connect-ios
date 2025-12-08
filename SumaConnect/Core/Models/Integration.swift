//
//  Integration.swift
//  SumaConnect
//
//  Created by Alberto Orrantia on 07/12/25.
//

import Foundation

struct Integration: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let provider: String
    let scopes: [String]
}
