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
    var fontSize: CGFloat = 24

    var body: some View {
        ZStack {
            TextField("", text: $text)
                .placeholder(when: text.isEmpty) {
                    Text(placeholderText).foregroundColor(Color(UIColor(named: "AccentGrayDarker")!))
                        .font(.system(size: fontSize, weight: .bold))
                }
                .keyboardType(.numberPad)
                .multilineTextAlignment(.leading)
                .font(.system(size: fontSize, weight: .black))
                .focused($focused, equals: field)
            
            if (!self.text.isEmpty) {
                HStack {
                    Spacer()
                    Button(action: {
                        self.text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color(UIColor(named: "AccentGrayDarker")!))
                            .font(.system(size: 20, weight: .black))
                    }
                }
            }
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
