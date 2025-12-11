//
//  SumaTitle.swift
//  SumaConnect
//
//  Created by Alberto Orrantia on 10/12/25.
//

import SwiftUI

struct SumaTitle: View {
    
    // Due to MVP purposes, we will manage this as the logo itself
    // Overridable
    
    enum LayoutSyle {
        case singleLine
        case stacked
    }
    
    var fontSize: CGFloat = 40
    var style: LayoutSyle = .singleLine
    
    var body: some View {
        switch style {
        case .singleLine:
            Text("Suma Connect")
                .font(.system(size: fontSize, weight: .heavy))
                .foregroundColor(Color.Suma.lightBlue)
                .shadow(color: .black.opacity(0.45), radius: 6, y: 3)
        case .stacked:
            VStack(spacing: -4) {
                Text("Suma")
                Text("Connect")
            }
            .font(.system(size: fontSize, weight: .heavy))
            .foregroundColor(Color.Suma.lightBlue)
            .shadow(color: .black.opacity(0.35), radius: 12, x: 6 , y: 3)
        }
    }
}

#Preview {
    SumaTitle()
}
