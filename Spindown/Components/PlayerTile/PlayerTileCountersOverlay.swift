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
        VStack(spacing: 10) {
            if (self.isActive) {
                Button(action: add) {
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 26)
                            .opacity(0.4)
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 1, y: 1)
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .semibold))
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
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .frame(height: 17)
                        .shadow(color: .black.opacity(0.2), radius: 3)
                    Image(badge)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 29)
                }
                .opacity(self.activeCounter == target ? 1 : 0.4)
            }
            
            if (self.isActive) {
                Button(action: remove) {
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 26)
                            .opacity(0.4)
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 2, y: 2)
                        Image(systemName: "minus")
                            .font(.system(size: 18, weight: .semibold))
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
            
            VStack {
                Spacer()
                
                Image(systemName: "chevron.compact.up")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white.opacity(0.2))
                    .padding(10)
                    .shadow(color: .black.opacity(0.1), radius: 2)
                    .transition(.push(from: .leading))
            }
            
            OverlayDragGestureHandler(
                height: $height,
                isFullHeight: $isFullHeight,
                dragCompletionPercentage: $completionPercentage,
                showOverlay: $showOverlay
            )
            
            if (isFullHeight) {
                ScrollView(.horizontal, showsIndicators: false) {
                    ZStack {
                        HStack(spacing: 20) {
                            ContentDivider()

                            CounterTile(
                                target: .tax,
                                value: player.tax,
                                add: { player.addCounter(.tax) },
                                remove: { player.removeCounter(.tax) },
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
                            
                            ContentDivider()
                            
                            Button(action: {
                                withAnimation {
                                    player.toggleMonarchy()
                                }
                            }) {
                                VStack(spacing: 15) {
                                    Spacer()
                                    
                                    VStack {
                                        if(!player.monarch) {
                                            Image("CrownBadge")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 60)
                                                .rotationEffect(Angle(degrees: 10))
                                        } else {
                                            Image("CrownBadgeBroken")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 60)
                                        }
                                    }
                                    
                                    Text("\(!player.monarch ? "Take" : "Yield") The Crown")
                                        .font(.system(size: 10, weight: .black, design: .rounded))
                                        .textCase(.uppercase)
                                        .foregroundColor(.white)
                                        .frame(width: 110)
                                    Spacer()
                                }
                                .shadow(color: .black.opacity(0.1), radius: 2, x: 1, y: 1)
                            }
                            .frame(width: 110, height: 110)
                            
                            ContentDivider()
                        }
                        .padding(.horizontal)
                        Spacer()
                    }
                }
            }
        }
        .onAppear {
            if (self.selectedCounter != nil) {
                self.activeCounter = self.selectedCounter!
            }
        }
    }
    
    struct ContentDivider: View {
        var body: some View {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [.white.opacity(0.2), .white.opacity(0.15)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 4, height: 120)
                .cornerRadius(2)
                .shadow(color: .black.opacity(0.1), radius: 2, x: 1, y: 1)
        }
    }
}
