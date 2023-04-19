//
//  ContentDivider.swift
//  Spindown
//
//  Created by Tyler Reckart on 4/19/23.
//

import SwiftUI

struct ContentDivider: View {
    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [.white.opacity(0.2), .white.opacity(0.15)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(width: 4, height: 80)
            .cornerRadius(2)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 1, y: 1)
    }
}
