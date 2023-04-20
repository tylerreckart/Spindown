//
//  PlayerTile.swift
//  Spindown
//
//  Created by Tyler Reckart on 1/29/23.
//

import SwiftUI

struct CommanderDamageTargetOverlay: View {
    @Binding var selectedPlayer: Participant?

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                HStack {
                    Image(systemName: "chevron.compact.left")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white.opacity(0.2))
                        .padding(10)
                        .shadow(color: .black.opacity(0.1), radius: 2)
                        .transition(.push(from: .bottom))
                    Spacer()
                    Image(systemName: "chevron.compact.right")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white.opacity(0.2))
                        .padding(10)
                        .shadow(color: .black.opacity(0.1), radius: 2)
                        .transition(.push(from: .bottom))
                }
                Spacer()
            }
        
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

struct CommanderDamageCounterOverlay: View {
    @ObservedObject var player: Participant
    
    var target: Participant
    
    @State private var index: Int?

    var body: some View {
        ZStack {
            VStack {
                Text("Damage Dealt")
                    .font(.system(size: 10, weight: .black, design: .rounded))
                    .textCase(.uppercase)
                    .foregroundColor(.white)
                    .padding(20)
                Spacer()
            }
            
            ZStack {
                if (index != nil) {
                    Text("\(player.cmdrDamageDealt[index!].total)")
                        .font(.system(size: 100, weight: .light, design: .rounded))
                        .shadow(color: .black.opacity(0.2), radius: 4)
                        .transition(.scale(scale: 0.4))
                } else {
                    Text("0")
                        .font(.system(size: 100, weight: .light, design: .rounded))
                        .shadow(color: .black.opacity(0.2), radius: 4)
                        .transition(.scale(scale: 0.4))
                }
                
                HStack {
                    Button(action: incrementDamage) {
                        ZStack {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 50)
                                .opacity(0)
                            
                            Image(systemName: "plus")
                                .foregroundColor(.white.opacity(0.5))
                                .font(.system(size: 32, weight: .regular, design: .rounded))
                                .shadow(color: .black.opacity(0.2), radius: 2)
                        }
                    }
                    Spacer()
                    Button(action: decrementDamage) {
                        ZStack {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 50)
                                .opacity(0)
                            
                            Image(systemName: "minus")
                                .foregroundColor(.white.opacity(0.5))
                                .font(.system(size: 32, weight: .regular, design: .rounded))
                                .shadow(color: .black.opacity(0.2), radius: 2)
                        }
                    }
                }
                .frame(maxWidth: 220)
            }
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .overlay(LinearGradient(
                    colors: [.black.opacity(0.8), .black.opacity(0.2)],
                    startPoint: .top,
                    endPoint: .bottom
                ))
        )
        .onAppear {
            self.index = player.cmdrDamageDealt.firstIndex(where: { target.id == $0.player.id })
        }
    }
    
    func incrementDamage() -> Void {
        if (index != nil) {
            player.cmdrDamageDealt[index!].total = player.cmdrDamageDealt[index!].total + 1
            target.incrementCmdrDamage()
        } else {
            var entry = CommanderDamageDealt(player: target, total: 1)
            player.cmdrDamageDealt.append(entry)
        }
    }
    
    func decrementDamage() -> Void {
        if (index != nil) {
            let nextTotal = player.cmdrDamageDealt[index!].total - 1
            
            if (nextTotal >= 0) {
                player.cmdrDamageDealt[index!].total = player.cmdrDamageDealt[index!].total - 1
            }

            target.decrementCmdrDamage()
        } else {
            var entry = CommanderDamageDealt(player: target, total: 0)
            player.cmdrDamageDealt.append(entry)
        }
    }
}

struct PlayerTile: View {
    @ObservedObject var player: Participant
    
    @Binding var selectedPlayer: Participant?

    var showLifeTotalCalculator: () -> Void
    
    // Overlay display parameters.
    @State private var overlayHeight: CGFloat = 0
    @State private var overlayIsFullHeight: Bool = false
    @State private var dragCompletionPercentage: CGFloat = 0
    
    // Player options overlay.
    @State private var showOptionsOverlay: Bool = false
    
    // Player counters overlay (only valid if player has existing active counters).
    @State private var selectedCounter: Counter?
    
    @State private var autoAnimate: Bool = false
    
    @State private var size: CGSize?
    @State private var greatestFiniteHeight: CGFloat = 0
    
    @State private var timer = Timer.publish(every: 0.01, on: .main, in: .common)

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Color.clear
                    .contentShape(Rectangle())
                    .onAppear {
                        self.greatestFiniteHeight = geometry.size.height
                    }
                    .zIndex(-1)
            }
    
            ZStack {
                ZStack {
                    OverlayDragGestureHandler(
                        height: $overlayHeight,
                        isFullHeight: $overlayIsFullHeight,
                        dragCompletionPercentage: $dragCompletionPercentage,
                        showOverlay: $showOptionsOverlay
                    )
                    
                    ZStack {
                        Button(action: { showLifeTotalCalculator() }) {
                            Text("\(player.lifeTotal)")
                                .font(.system(size: 100, weight: .light, design: .rounded))
                                .shadow(color: .black.opacity(0.2), radius: 4)
                                .transition(.scale(scale: 0.4))
                        }
                        .opacity(1 - dragCompletionPercentage)
                        .scaleEffect(1 - (dragCompletionPercentage / 5))
                        
                        HStack {
                            Button(action: { player.incrementLifeTotal() }) {
                                ZStack {
                                    Circle()
                                        .fill(.ultraThinMaterial)
                                        .frame(width: 50)
                                        .opacity(0)
                                    
                                    Image(systemName: "plus")
                                        .foregroundColor(.white.opacity(0.5))
                                        .font(.system(size: 32, weight: .regular, design: .rounded))
                                        .shadow(color: .black.opacity(0.2), radius: 2)
                                }
                            }
                            Spacer()
                            Button(action: { player.decrementLifeTotal() }) {
                                ZStack {
                                    Circle()
                                        .fill(.ultraThinMaterial)
                                        .frame(width: 50)
                                        .opacity(0)
                                    
                                    Image(systemName: "minus")
                                        .foregroundColor(.white.opacity(0.5))
                                        .font(.system(size: 32, weight: .regular, design: .rounded))
                                        .shadow(color: .black.opacity(0.2), radius: 2)
                                }
                            }
                        }
                        .frame(maxWidth: 260)
                        .opacity(1 - dragCompletionPercentage)
                        .scaleEffect(1 - (dragCompletionPercentage / 5))
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: greatestFiniteHeight)
                .background(
                    Image(player.theme?.backgroundKey ?? "")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                )
                
                PlayerBadges(player: player, showOverlay: $showOptionsOverlay, selectedCounter: $selectedCounter)
                
                if (showOptionsOverlay && overlayHeight > 0) {
                    PlayerTileOptionsOverlay(
                        player: player,
                        selectedPlayer: $selectedPlayer,
                        height: $overlayHeight,
                        completionPercentage: $dragCompletionPercentage,
                        isFullHeight: $overlayIsFullHeight,
                        showOverlay: $showOptionsOverlay
                    )
                }
                
                if (self.selectedPlayer != nil) {
                    if (player != selectedPlayer!) {
                        CommanderDamageCounterOverlay(player: player, target: selectedPlayer!)
                            .transition(.opacity)
                    } else {
                        CommanderDamageTargetOverlay(selectedPlayer: $selectedPlayer)
                            .transition(.opacity)
                    }
                }
            }
        }
        .onChange(of: showOptionsOverlay) { newState in
            if (newState == true) {
                self.timer = Timer.publish(every: 0.01, on: .main, in: .common)
                timer.connect()
            } else {
                if (self.overlayIsFullHeight || self.overlayHeight > 0) {
                    self.overlayHeight = 0
                    self.overlayIsFullHeight = false
                }
            }
        }
        .onReceive(timer) { recieved in
            let diff = self.overlayHeight + 20

            if (diff < greatestFiniteHeight) {
                withAnimation {
                    self.overlayHeight = diff
                    self.dragCompletionPercentage = self.overlayHeight / greatestFiniteHeight
                }
            } else if (diff >= greatestFiniteHeight) {
                withAnimation {
                    self.overlayHeight = greatestFiniteHeight
                    self.overlayIsFullHeight = true
                    timer.connect().cancel()
                }
            }
        }
        .clipped()
        .cornerRadius(8)
    }
}
