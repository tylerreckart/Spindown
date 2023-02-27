//
//  StyledTextField.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/27/23.
//

import SwiftUI

struct StyledTextField: View {
    var placeholderText: String
    @Binding var text: String
    var field: FocusField
    @FocusState private var focused: FocusField?
    var focusOnAppear: Bool = false

    var body: some View {
        HStack {
            TextField("", text: $text)
                .placeholder(when: text.isEmpty) {
                    Text(placeholderText).foregroundColor(Color(UIColor(named: "AccentGrayDarker")!))
                        .font(.system(size: 24, weight: .bold))
                }
                .keyboardType(.numberPad)
                .multilineTextAlignment(.leading)
                .font(.system(size: 24, weight: .black))
                .focused($focused, equals: field)
        }
        .padding()
        .background(Color(UIColor(named: "AccentGrayDarker")!).opacity(0.25))
        .cornerRadius(4)
        .padding(4)
        .background(Color(UIColor(named: "DeepGray")!))
        .cornerRadius(6)
        .padding(4)
        .background(
            Color(UIColor(named: "AccentGrayDarker")!)
        )
        .cornerRadius(8)
        .onAppear {
            if (self.focusOnAppear) {
                focused = field
            }
        }
    }
}
