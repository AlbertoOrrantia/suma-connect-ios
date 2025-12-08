//
//  HTTPMethod.swift
//  SumaConnect
//
//  Created by Alberto Orrantia on 08/12/25.
//

import Foundation

// MVP will only have GET & POST, as they are only needed for the Vapor routes; if the API grows, edit and grow this enum
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}
