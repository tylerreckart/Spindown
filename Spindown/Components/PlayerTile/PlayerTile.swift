//
//  PlayerTile.swift
//  Spindown
//
//  Created by Tyler Reckart on 1/29/23.
//

import SwiftUI

struct PlayerTile: View {
    @ObservedObject var player: Participant

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
                        height: $overlayHeight,
                        completionPercentage: $dragCompletionPercentage,
                        isFullHeight: $overlayIsFullHeight,
                        showOverlay: $showOptionsOverlay
                    )
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
