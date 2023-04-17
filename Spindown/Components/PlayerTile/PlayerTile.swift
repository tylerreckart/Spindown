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
    
    @State private var overlayHeight: CGFloat = 0
    @State private var overlayIsFullHeight: Bool = false
    @State private var dragCompletionPercentage: CGFloat = 0

    var body: some View {
        ZStack {
            ZStack {
                OverlayDragGestureHandler(height: $overlayHeight, isFullHeight: $overlayIsFullHeight, dragCompletionPercentage: $dragCompletionPercentage)
                
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Image(player.theme?.backgroundKey ?? "")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            )
            
            PlayerBadges()
            
            if (overlayHeight > 0) {
                PlayerTileOptionsOverlay(height: $overlayHeight, completionPercentage: $dragCompletionPercentage, isFullHeight: $overlayIsFullHeight)
            }
        }
        .clipped()
        .cornerRadius(8)
    }
}
