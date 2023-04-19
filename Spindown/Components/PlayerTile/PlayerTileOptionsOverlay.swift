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
                CounterOptionsStack(player: player, activeCounter: $activeCounter)
            }
        }
    }
}
