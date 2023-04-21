//
//  LostPlayerOverlay.swift
//  Spindown
//
//  Created by Tyler Reckart on 4/20/23.
//

import SwiftUI

struct LostPlayerOverlay: View {
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 5) {
                Text("You Died")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                Text("Try Again Next Time")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .tracking(0.5)
            }
            .textCase(.uppercase)
            .shadow(color: .black.opacity(0.2), radius: 4)
            .transition(.scale(scale: 0.4))
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .overlay(LinearGradient(
                    colors: [.black.opacity(0.8), .black.opacity(0.4)],
                    startPoint: .top,
                    endPoint: .bottom
                ))
        )
    }
}
