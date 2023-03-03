//
//  UIButtonStacked.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/27/23.
//

import SwiftUI

struct UIButtonStacked: View {
    var text: String
    var symbol: String?
    var color: UIColor
    var action: () -> ()

    var body: some View {
        Button(action: { action() }) {
            VStack(alignment: .center, spacing: 5) {
                Spacer()
                if (symbol != nil) {
                    Image(systemName: symbol!)
                        .font(.system(size: 16, weight: .black))
                }
                Text(text)
                    .font(.system(size: 12, weight: .black))
                Spacer()
            }
            .foregroundColor(Color(.white))
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 80)
            .background(Color(color).overlay(LinearGradient(colors: [.white.opacity(0.1), .clear], startPoint: .top, endPoint: .bottom)))
            .cornerRadius(8)
        }
    }
}

