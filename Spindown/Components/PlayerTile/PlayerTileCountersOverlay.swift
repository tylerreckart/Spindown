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
                ZStack {
                    Image("CounterTabletBackground")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 70)
                    
                    VStack {
                        Text("\(value)")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .frame(height: 17)
                            .shadow(color: .black.opacity(0.2), radius: 3)
                        Image(badge)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 29)
                    }
                }
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
    
    @Binding var height: CGFloat
    @Binding var completionPercentage: CGFloat
    @Binding var isFullHeight: Bool
    @Binding var showOverlay: Bool
    @Binding var selectedCounter: Counter?

    @State private var activeCounter: Counter = .poison

    var body: some View {
        ZStack {
            VStack {
                Rectangle().fill(.ultraThinMaterial)
                    .edgesIgnoringSafeArea(.all)
                    .shadow(color: .black.opacity(0.1), radius: 3)
                    .frame(height: height)
                
                if (!isFullHeight) {
                    Spacer()
                }
            }
            
            OverlayDragGestureHandler(
                height: $height,
                isFullHeight: $isFullHeight,
                dragCompletionPercentage: $completionPercentage,
                showOverlay: $showOverlay
            )
            
            if (isFullHeight) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        Spacer()
                        
                        CounterTile(
                            target: .energy,
                            value: player.poison,
                            add: { player.addCounter(.poison) },
                            remove: { player.removeCounter(.poison) },
                            badge: "TaxBadge",
                            activeCounter: $activeCounter
                        )
                        
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
        .onAppear {
            if (self.selectedCounter != nil) {
                self.activeCounter = self.selectedCounter!
            }
        }
    }
}
