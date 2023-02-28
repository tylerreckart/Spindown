//
//  UIButtonTile.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/27/23.
//

import SwiftUI

struct UIButtonTile: View {
    var text: String
    var symbol: String?
    var color: UIColor
    var action: () -> ()

    var body: some View {
        Button(action: { action() }) {
            VStack(alignment: .center) {
                HStack(alignment: .center) {
                    if (symbol != nil) {
                        Image(systemName: symbol!)
                    }
                    Text(text)
                }
            }
            .font(.system(size: 24, weight: .black))
            .foregroundColor(Color(.white))
            .padding()
            .frame(width: 100, height: 100)
            .background(Color(color).overlay(LinearGradient(colors: [.white.opacity(0.1), .clear], startPoint: .top, endPoint: .bottom)))
            .cornerRadius(8)
        }
    }
}
