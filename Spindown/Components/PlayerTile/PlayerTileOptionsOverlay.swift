//
//  PlayerTileOptionsOverlay.swift
//  Spindown
//
//  Created by Tyler Reckart on 4/17/23.
//

import SwiftUI

struct PlayerTileOptionsOverlay: View {
    @ObservedObject var player: Participant

    @Binding var height: CGFloat
    @Binding var completionPercentage: CGFloat
    @Binding var isFullHeight: Bool
    @Binding var showOverlay: Bool
    
    @State private var activeCounter: Counter?
    
    var body: some View {
        ZStack {
            VStack {
                Rectangle().fill(.ultraThinMaterial)
                    .edgesIgnoringSafeArea(.all)
                    .frame(maxWidth: .infinity, maxHeight: height)
                
                if (!isFullHeight || self.completionPercentage > 0.9) {
                    Spacer()
                }
            }
            
            if (isFullHeight) {
                VStack {
                    Spacer()
                    
                    Image(systemName: "chevron.compact.up")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white.opacity(0.2))
                        .padding(10)
                        .shadow(color: .black.opacity(0.1), radius: 2)
                        .transition(.push(from: .bottom))
                }
            }
            
            OverlayDragGestureHandler(
                height: $height,
                isFullHeight: $isFullHeight,
                dragCompletionPercentage: $completionPercentage,
                showOverlay: $showOverlay
            )
            
            if (self.completionPercentage > 0.9) {
                ScrollView(.horizontal, showsIndicators: false) {
                    CounterOptionsStack(player: player, activeCounter: $activeCounter)
                        .zIndex(10)
                        .transition(.scale(scale: 0.9).combined(with: .opacity))
                }
            }
        }
    }
}
