//
//  Button.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/1/23.
//

import SwiftUI

struct UIButton: View {
    var text: String
    var symbol: String?
    var color: UIColor
    var action: () -> ()

    var body: some View {
        Button(action: { action() }) {
            HStack {
                if (symbol != nil) {
                    Image(systemName: symbol!)
                }
                Text(text)
            }
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(Color(.white))
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(color).overlay(LinearGradient(colors: [.white.opacity(0.1), .clear], startPoint: .top, endPoint: .bottom)))
            .cornerRadius(8)
        }
    }
}
