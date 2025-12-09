//
//  ChatMessage.swift
//  SumaConnect
//
//  Created by Alberto Orrantia on 08/12/25.
//

import Foundation

enum ChatSender {
    case user
    case charlie
    case system
}

// Represents one message in the UI; for MVP purposes, inmemory chat will only be required
struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let sender: ChatSender
    let createdAt: Date
}
