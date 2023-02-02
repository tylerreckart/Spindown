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
            .font(.system(size: 16, weight: .black))
            .foregroundColor(Color(.white))
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(color).overlay(LinearGradient(colors: [.white.opacity(0.1), .clear], startPoint: .top, endPoint: .bottom)))
            .cornerRadius(8)
        }
    }
}

struct UIButtonOutlined: View {
    var text: String
    var symbol: String?
    var fill: UIColor
    var color: UIColor
    var action: () -> ()

    var body: some View {
        Button(action: { action() }) {
            HStack {
                if (symbol != nil) {
                    Image(systemName: symbol!)
                        .shadow(color: Color.black.opacity(0.1), radius: 5)
                }
                Text(text)
                    .shadow(color: Color.black.opacity(0.1), radius: 5)
            }
            .font(.system(size: 16, weight: .black))
            .foregroundColor(Color(.white))
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 60)
            .background(
                Color(color).opacity(0.4)
                    .overlay(LinearGradient(colors: [.white.opacity(0.1), .clear], startPoint: .top, endPoint: .bottom))
                    .overlay(Rectangle().fill(Color(fill)).frame(maxWidth: 272, maxHeight: 52).cornerRadius(6)))
            .cornerRadius(8)
        }
    }
}
