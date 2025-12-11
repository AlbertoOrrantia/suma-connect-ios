//
//  SessionViewModel.swift
//  SumaConnect
//
//  Created by Alberto Orrantia on 09/12/25.
//

import Foundation
import Combine

// WIll include simple login, OAuth and real sign up will be supported in the future
@MainActor
final class SessionViewModel: ObservableObject {
    @Published private(set) var userId: String?
    @Published private(set) var userName: String?
    @Published private(set) var isAuthenticated: Bool = false
    
    // Data persistancy
    private let kUserIdKey = "suma_session_user_id"
    private let kUserName = "suma_session_user_name"
    
    init(userId: String? = nil, userName: String? = nil) {
        if let userId = userId {
            self.userId = userId
            self.userName = userName
            self.isAuthenticated = true
        } else {
            restoreSession()
        }
    }
    
    private func restoreSession() {
        if let savedId = UserDefaults.standard.string(forKey: kUserIdKey) {
            self.userId = savedId
            self.userName = UserDefaults.standard.string(forKey: kUserName)
            self.isAuthenticated = true
        }
    }
    
    // MARK: - Session Control
    func startSession(userId: String, userName: String?) {
        self.userId = userId
        self.userName = userName
        self.isAuthenticated = true
        
        // Persist session
        UserDefaults.standard.set(userId, forKey: kUserIdKey)
        if let name = userName {
            UserDefaults.standard.set(name, forKey: kUserName)
        }
    }
    
    // No logout button for MVP
    func logout() {
        userId = nil
        userName = nil
        isAuthenticated = false
        
        // Clear persistance
        UserDefaults.standard.removeObject(forKey: kUserIdKey)
        UserDefaults.standard.removeObject(forKey: kUserName)
    }
}
