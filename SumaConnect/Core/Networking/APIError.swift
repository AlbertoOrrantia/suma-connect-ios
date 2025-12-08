//
//  APIError.swift
//  SumaConnect
//
//  Created by Alberto Orrantia on 08/12/25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case decodingFailed
    case serverError(String)
    case networkError(Error)
}
