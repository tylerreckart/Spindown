//
//  CounterTile.swift
//  Spindown
//
//  Created by Tyler Reckart on 4/18/23.
//

import SwiftUI

struct CounterTile: View {
    var target: Counter
    var value: Int
    var add: () -> ()
    var remove: () -> ()
    var badge: String

    @Binding var activeCounter: Counter?
    
    @State private var isActive: Bool = false
    
    var body: some View {
        VStack(spacing: 10) {
            if (self.isActive) {
                Button(action: add) {
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 32)
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 1, y: 1)
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .semibold))
                    }
                }
                .frame(width: 32, height: 32)
                .transition(
                    .asymmetric(
                        insertion: .push(from: .bottom).combined(with: .opacity),
                        removal: .push(from: .top).combined(with: .opacity)
                    )
                )
            }
            
            Button(action: {
                if (self.activeCounter != target) {
                    self.activeCounter = target
                } else {
                    self.activeCounter = nil
                }
            }) {
                VStack {
                    Text("\(value)")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .frame(height: 17)
                        .shadow(color: .black.opacity(0.2), radius: 3)
                    Image(badge)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32)
                }
                .opacity(self.activeCounter == target ? 1 : 0.4)
            }
            
            if (self.isActive) {
                Button(action: remove) {
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 32)
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 2, y: 2)
                        Image(systemName: "minus")
                            .font(.system(size: 18, weight: .semibold))
                    }
                }
                .frame(width: 32, height: 32)
                .transition(
                    .asymmetric(
                        insertion: .push(from: .top).combined(with: .opacity),
                        removal: .push(from: .bottom).combined(with: .opacity)
                    )
                )
            }
        }
        .foregroundColor(.white)
        .onAppear {
            if (activeCounter == target) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
        .onChange(of: activeCounter) { newState in
            if (newState == target) {
                withAnimation(.spring()) {
                    self.isActive = true
                }
            } else {
                withAnimation(.spring()) {
                    self.isActive = false
                }
            }
        }
    }
}
