//
//  OnboardingBackButton.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/27/23.
//

import SwiftUI

struct OnboardingBackButton: View {
    var action: () -> Void

    var body: some View {
        HStack {
            Button(action: action) {
                Image(systemName: "arrow.uturn.left")
                    .font(.system(size: 18, weight: .black))
                Text("Back")
                    .font(.system(size: 18, weight: .black))
            }
            Spacer()
        }
        .foregroundColor(.white)
        .padding()
    }
}
