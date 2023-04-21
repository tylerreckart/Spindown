//
//  CommanderDamageTargetOverlay.swift
//  Spindown
//
//  Created by Tyler Reckart on 4/20/23.
//

import SwiftUI

struct CommanderDamageTargetOverlay: View {
    @Binding var selectedPlayer: Participant?

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                VStack {
                    Text("Commander")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                    Text("Damage Received")
                        .font(.system(size: 23.75, weight: .bold, design: .rounded))
                }
                .textCase(.uppercase)
                .shadow(color: .black.opacity(0.2), radius: 4)
                .transition(.scale(scale: 0.4))
                
                Button(action: {
                    withAnimation(.spring()) {
                        self.selectedPlayer = nil
                    }
                }) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 12, weight: .black, design: .rounded))
                    Text("Back To The Game")
                        .font(.system(size: 12, weight: .black, design: .rounded))
                }
                .frame(width: 160)
                .padding()
                .background(Color(UIColor(named: "PrimaryRed")!))
                .cornerRadius(.infinity)
                .shadow(radius: 3, y: 2)
                Spacer()
            }
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .overlay(LinearGradient(
                    colors: [.black.opacity(1), .black.opacity(0.8)],
                    startPoint: .top,
                    endPoint: .bottom
                ))
        )
    }
}
