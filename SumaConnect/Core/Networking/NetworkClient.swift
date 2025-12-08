//
//  NetworkClient.swift
//  SumaConnect
//
//  Created by Alberto Orrantia on 08/12/25.
//

import Foundation

// Simple and lightweight network client for MVP purpose.
// URLSession is injected to allow testing and avoid external dependencies
final class NetworkClient {
    static let shared = NetworkClient()
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable> (
        _ urlString: String,
        method: HTTPMethod = .get,
        body: Encodable? = nil
    ) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
                throw APIError.serverError("Status Code: \(http.statusCode)")
            }
            
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw APIError.decodingFailed
            }
        } catch {
            if let apiError = error as? APIError {
                throw apiError
            }
            throw APIError.networkError(error)
        }
        
    }
}
