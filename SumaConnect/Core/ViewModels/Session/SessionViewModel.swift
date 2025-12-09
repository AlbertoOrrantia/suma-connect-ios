//
//  SessionViewModel.swift
//  SumaConnect
//
//  Created by Alberto Orrantia on 09/12/25.
//

import Foundation
import Combine

// MVP will only control login, will include chat and integrations on the future.
// WIll include simple login, OAuth and real sign up will be supported in the future
@MainActor
final class SessionViewModel: ObservableObject {
    @Published private(set) var userId: String?
    @Published private(set) var userName: String?
    @Published private(set) var isAuthenticated: Bool = false
    
    init(userId: String? = nil, userName: String? = nil) {
        self.userId = userId
        self.userName = userName
        self.isAuthenticated = userId != nil
    }
    // MARK: - Session Control
    func startSession(userId: String, userName: String?) {
        self.userId = userId
        self.userName = userName
        self.isAuthenticated = true
    }
    
    func logout() {
        userId = nil
        userName = nil
        isAuthenticated = false
    }
}
