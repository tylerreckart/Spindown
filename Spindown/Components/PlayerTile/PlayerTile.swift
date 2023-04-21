//
//  PlayerTile.swift
//  Spindown
//
//  Created by Tyler Reckart on 1/29/23.
//

import SwiftUI

struct PlayerTile: View {
    @ObservedObject var player: Participant
    
    @Binding var selectedPlayer: Participant?
    
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
    @State private var greatestFiniteWidth: CGFloat = 0
    
    @State private var timer = Timer.publish(every: 0.01, on: .main, in: .common)
    
    @Binding var orientation: UIDeviceOrientation?
    
    let orientationListener = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
        .makeConnectable()
        .autoconnect()
    
    struct LifeCount: View {
        var lifeTotal: Int
        var orientation: UIDeviceOrientation
        var visibility: CGFloat
        
        var body: some View {
            Text("\(lifeTotal)")
                .font(
                    .system(
                        size: orientation != .landscapeLeft && orientation != .landscapeRight ? 48 : 100,
                        weight: orientation != .landscapeLeft && orientation != .landscapeRight ? .regular : .light,
                        design: .rounded
                    )
                )
                .shadow(color: .black.opacity(0.2), radius: 4)
                .transition(.scale(scale: 0.4))
                .opacity(1 - visibility)
                .scaleEffect(1 - (visibility / 5))
        }
    }
    
    struct LifeCounterButton: View {
        var action: () -> ()
        var symbol: String
        var visibility: CGFloat
        var showBackground: Bool = true

        var body: some View {
            Button(action: action) {
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 40)
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 1, y: 1)
                        .opacity(showBackground ? 1 : 0)
                    
                    Image(systemName: symbol)
                        .foregroundColor(.white.opacity(0.5))
                        .font(.system(size: 28, weight: .regular, design: .rounded))
                }
            }
            .frame(maxWidth: 120)
            .opacity(1 - visibility)
            .scaleEffect(1 - (visibility / 5))
        }
    }
    
    struct PortraitPlayerControls: View {
        @ObservedObject var player: Participant
        
        var orientation: UIDeviceOrientation
    
        @Binding var dragCompletionPercentage: CGFloat
    
        var body: some View {
            VStack(spacing: 20) {
                LifeCounterButton(action: { player.incrementLifeTotal() }, symbol: "plus", visibility: dragCompletionPercentage)
                LifeCount(lifeTotal: player.lifeTotal, orientation: orientation, visibility: dragCompletionPercentage)
                LifeCounterButton(action: { player.decrementLifeTotal() }, symbol: "minus", visibility: dragCompletionPercentage)
            }
        }
    }
    
    struct LandscapePlayerControls: View {
        @ObservedObject var player: Participant
        
        var orientation: UIDeviceOrientation
    
        @Binding var dragCompletionPercentage: CGFloat
    
        var body: some View {
            ZStack {
                LifeCount(lifeTotal: player.lifeTotal, orientation: orientation, visibility: dragCompletionPercentage)
                
                HStack(spacing: 0) {
                    LifeCounterButton(action: { player.incrementLifeTotal() }, symbol: "plus", visibility: dragCompletionPercentage)
                    Spacer()
                    LifeCounterButton(action: { player.decrementLifeTotal() }, symbol: "minus", visibility: dragCompletionPercentage)
                }
                .frame(maxWidth: 340)
            }
        }
    }

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Color.clear
                    .contentShape(Rectangle())
                    .onAppear {
                        self.greatestFiniteHeight = geometry.size.height
                        self.greatestFiniteWidth = geometry.size.width
                    }
                    .onChange(of: orientation) { _ in
                        self.greatestFiniteHeight = geometry.size.height
                        self.greatestFiniteWidth = geometry.size.width
                    }
            }

            ZStack {
                ZStack {
                    OverlayDragGestureHandler(
                        height: $overlayHeight,
                        isFullHeight: $overlayIsFullHeight,
                        dragCompletionPercentage: $dragCompletionPercentage,
                        showOverlay: $showOptionsOverlay
                    )
                    
                    if ((self.orientation == .landscapeLeft || self.orientation == .landscapeRight) || greatestFiniteWidth > 300){
                        LandscapePlayerControls(
                            player: player,
                            orientation: .landscapeLeft,
                            dragCompletionPercentage: $dragCompletionPercentage
                        )
                    } else {
                        PortraitPlayerControls(
                            player: player,
                            orientation: .portrait,
                            dragCompletionPercentage: $dragCompletionPercentage
                        )
                    }
                }
                .foregroundColor(.white)

                PlayerBadges(
                    player: player,
                    showOverlay: $showOptionsOverlay,
                    selectedCounter: $selectedCounter,
                    orientation: $orientation
                )
                
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
                
                if (player.isLoser) {
                    LostPlayerOverlay()
                        .transition(.opacity)
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
            .background(
                Image(player.theme?.backgroundKey ?? "")
                    .resizable()
                    .frame(width: greatestFiniteWidth + 30, height: greatestFiniteHeight + 30)            )
        }
        .onChange(of: showOptionsOverlay) { newState in
            if (newState == true) {
                self.timer = Timer.publish(every: 0.01, on: .main, in: .common)
                
                _ = timer.connect()
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
        .cornerRadius(8)
        .onAppear {
            print(self.orientation?.rawValue)
        }
    }
}
