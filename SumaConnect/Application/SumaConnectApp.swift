//
//  SumaConnectApp.swift
//  SumaConnect
//
//  Created by Alberto Orrantia on 07/12/25.
//

import SwiftUI

@main
struct SumaConnectApp: App {
    @StateObject private var session = SessionViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(session)
        }
    }
}
