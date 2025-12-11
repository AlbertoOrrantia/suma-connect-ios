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
                .onOpenURL { url in
                    print("\(url)")
                    if url.host == "auth-success" {
                        NotificationCenter.default.post(name: NSNotification.Name("RefreshHome"), object: nil)
                    }
                }
        }
    }
}
