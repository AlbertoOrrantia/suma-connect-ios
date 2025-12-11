//
//  SumaHeaderView.swift
//  SumaConnect
//
//  Created by Alberto Orrantia on 10/12/25.
//

import SwiftUI

// Reusable header, as per MVP we willnot include logo.
struct SumaHeaderView: View {
    var body: some View {
        HStack {
            SumaTitle(fontSize: 24, style: .singleLine)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.top, 12)
        .padding(.bottom, 24)
        .background(Color.Suma.red.ignoresSafeArea(edges: .top))

    }
}

#Preview {
    ZStack {
        Color.Suma.darkGray.ignoresSafeArea()
        VStack {
            SumaHeaderView()
            Spacer()
        }
    }
}
