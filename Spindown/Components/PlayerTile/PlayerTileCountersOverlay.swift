//
//  PlayerTileCountersOverlay.swift
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
    @Binding var activeCounter: Counter
    
    @State private var isActive: Bool = false
    
    var body: some View {
        VStack(spacing: 4) {
            if (self.isActive) {
                Button(action: add) {
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 28)
                            .opacity(0)
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .semibold))
                    }
                }
                .transition(
                    .asymmetric(
                        insertion: .push(from: .bottom).combined(with: .opacity),
                        removal: .push(from: .top).combined(with: .opacity)
                    )
                )
            }
            
            Button(action: { self.activeCounter = target }) {
                VStack {
                    Text("\(value)")
                        .font(.system(size: 32, weight: .regular, design: .rounded))
                        .frame(height: 28)
                        .shadow(color: .black.opacity(0.2), radius: 3)
                    Image(badge)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32)
                }
                .padding(12)
                .frame(width: 75, height: 100)
                .background(.clear)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    .white.opacity(self.isActive ? 0.8 : 0.3),
                                    .white.opacity(self.isActive ? 0.7 : 0.2)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 4
                        )
                        .shadow(color: .black.opacity(0.2), radius: 3)
                )
            }
            
            if (self.isActive) {
                Button(action: remove) {
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 28)
                            .opacity(0)
                        Image(systemName: "minus")
                            .font(.system(size: 20, weight: .semibold))
                    }
                }
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

struct PlayerTileCountersOverlay: View {
    @ObservedObject var player: Participant

    @State private var activeCounter: Counter = .poison

    var body: some View {
        ZStack {
            Rectangle().fill(.ultraThinMaterial)
                .edgesIgnoringSafeArea(.all)
                .shadow(color: .black.opacity(0.1), radius: 3)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    Spacer()
                    
                    CounterTile(
                        target: .poison,
                        value: player.poison,
                        add: { player.addCounter(.poison) },
                        remove: { player.removeCounter(.poison) },
                        badge: "PoisonCounterBadge",
                        activeCounter: $activeCounter
                    )
                    
                    CounterTile(
                        target: .energy,
                        value: player.energy,
                        add: { player.addCounter(.energy) },
                        remove: { player.removeCounter(.energy) },
                        badge: "EnergyCounterBadge",
                        activeCounter: $activeCounter
                    )
                    
                    CounterTile(
                        target: .experience,
                        value: player.experience,
                        add: { player.addCounter(.experience) },
                        remove: { player.removeCounter(.experience) },
                        badge: "XPCounterBadge",
                        activeCounter: $activeCounter
                    )
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
    }
}
