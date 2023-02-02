//
//  SplashScreen.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/2/23.
//

import SwiftUI

struct SplashScreen: View {
    @Binding var setupStep: Int

    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 0) {
                Image("SpindownIcon")
                    .resizable()
                    .frame(maxWidth: 100, maxHeight: 100)
            }
            .padding(.bottom, 35)

            HStack {
                Spacer()
                    
                VStack(spacing: 20) {
                    UIButton(text: "Setup Game", symbol: "dice.fill", color: .systemBlue, action: { self.setupStep += 1 })
                        .frame(maxWidth: 280, maxHeight: 60)
                        .shadow(color: Color.black.opacity(0.1), radius: 10)
                    UIButtonOutlined(text: "Game History", symbol: "text.book.closed", fill: .black, color: .white, action: { self.setupStep += 1 })
                        .frame(maxWidth: 280, maxHeight: 60)
                        .shadow(color: Color.black.opacity(0.1), radius: 10)
                    UIButtonOutlined(text: "Settings", symbol: "gearshape", fill: .black, color: .white, action: { self.setupStep += 1 })
                        .frame(maxWidth: 280, maxHeight: 60)
                        .shadow(color: Color.black.opacity(0.1), radius: 10)
                }
                    
                Spacer()
            }
            Spacer()
        }
        .background(Color(.black))
    }
}
