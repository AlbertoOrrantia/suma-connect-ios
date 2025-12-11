//
//  SocialButton.swift
//  SumaConnect
//
//  Created by Alberto Orrantia on 10/12/25.
//

import SwiftUI

// Reusable buttons for social media log in, MVP will only have placeholders for Apple & Google
struct SocialButton: View {
    let text: String
    let iconName: String
    let isSystemImage: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                // We only have apple on SF so we can search for assets
                if isSystemImage {
                    Image(systemName: iconName)
                        .font(.system(size: 18, weight: .bold))
                } else {
                    Image(iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                }
                
                Text(text)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .foregroundColor(Color.Suma.white)
            .frame(maxWidth: .infinity, minHeight: 52)
            .background(Color.Suma.darkBlue)
            .clipShape(Capsule())
        }
    }
}
