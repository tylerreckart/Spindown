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
            .font(.system(size: 16, weight: .bold, design: .rounded))
            .frame(maxWidth: .infinity, maxHeight: 40)
            .foregroundColor(.primary)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(5)
    }
}

struct MenuOption: View {
    var text: String
    var textColor: UIColor = .white
    var background: UIColor

    var body: some View {
        Text(text)
            .font(.system(size: 16, weight: .black, design: .rounded))
            .foregroundColor(Color(textColor))
            .frame(maxWidth: .infinity, maxHeight: 40)
            .foregroundColor(.primary)
            .padding()
            .background(Color(background))
            .cornerRadius(12)
            .padding(5)
    }
}
