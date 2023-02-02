//
//  MenuOptions.swift
//  Spindown
//
//  Created by Tyler Reckart on 1/29/23.
//

import Foundation
import SwiftUI

struct MenuOptionOutlined: View {
    var text: String

    var body: some View {
        Text(text)
            .font(.system(size: 20, weight: .black))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: 80)
            .foregroundColor(.white)
            .padding()
            .background(
                Color(.systemGray6)
                    .overlay(LinearGradient(colors: [.white.opacity(0.1), .clear], startPoint: .top, endPoint: .bottom))
            )
            .cornerRadius(8)
            .padding()
    }
}

struct NumberMenuOption: View {
    var text: String
    var textColor: UIColor = .white
    var background: UIColor

    var body: some View {
        Text(text)
            .font(.system(size: 24, weight: .black))
            .foregroundColor(Color(textColor))
            .frame(width: 100, height: 100)
            .foregroundColor(.white)
            .padding()
            .background(Color(background))
            .cornerRadius(12)
    }
}


struct MenuOption: View {
    var text: String
    var textColor: UIColor = .white
    var background: UIColor

    var body: some View {
        Text(text)
            .font(.system(size: 20, weight: .black))
            .foregroundColor(Color(textColor))
            .frame(maxWidth: .infinity, maxHeight: 80)
            .foregroundColor(.white)
            .padding()
            .background(
                Color(.systemGray3)
                    .overlay(LinearGradient(colors: [.white.opacity(0.1), .clear], startPoint: .top, endPoint: .bottom))
            )
            .cornerRadius(8)
            .padding()
    }
}
