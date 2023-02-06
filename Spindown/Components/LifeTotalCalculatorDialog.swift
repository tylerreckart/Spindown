//
//  LifeTotalCalculatorDialog.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/6/23.
//

import SwiftUI

struct LifeTotalCalculatorDialog: View {
    @State private var dialogOpacity: Double = 0
    @State private var dialogOffset: Double = 0

    var body: some View {
        VStack {
            Text("Life Total Calculator")
        }
        .foregroundColor(.white)
        .frame(maxWidth: 300)
        .padding(30)
        .background(
            Color(.black)
                .overlay(LinearGradient(colors: [.white.opacity(0.05), .clear], startPoint: .top, endPoint: .bottom))
        )
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 15)
        .opacity(dialogOpacity)
        .scaleEffect(dialogOffset)
        .onAppear {
            withAnimation {
                self.dialogOpacity = 1
                self.dialogOffset = 1.1
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation {
                        self.dialogOffset = 1
                    }
                }
            }
        }
    }
}
