//
//  PlayerTileControls.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/27/23.
//

import SwiftUI

struct PlayerTileControls: View {
    @ObservedObject var player: Participant
    @Binding var activeSum: Counter
    var orientation: TileOrientation

    var body: some View {
        if (self.orientation == .portrait) {
            VStack(spacing: 0) {
                Button(action: { increment() }) {
                    Rectangle().fill(Color(player.color))
                }
                
                Button(action: { decrement() }) {
                    Rectangle().fill(Color(player.color))
                }
            }
        } else if (self.orientation == .landscape) {
            HStack(spacing: 0) {
                Button(action: { increment() }) {
                    Rectangle().fill(Color(player.color))
                }
                
                Button(action: { decrement() }) {
                    Rectangle().fill(Color(player.color))
                }
            }
        } else if (self.orientation == .landscapeReverse) {
            HStack(spacing: 0) {
                Button(action: { decrement() }) {
                    Rectangle().fill(Color(player.color))
                }
                
                Button(action: { increment() }) {
                    Rectangle().fill(Color(player.color))
                }
            }
        }
    }
    
    func increment() -> Void {
        HapticsManager.shared.impact(.light)

        if (self.activeSum == .lifeTotal) {
            player.incrementLifeTotal()
        } else {
            player.addCounter(self.activeSum)
        }
    }
    
    func decrement() -> Void {
        HapticsManager.shared.impact(.light)

        if (self.activeSum == .lifeTotal) {
            player.decrementLifeTotal()
        } else {
            player.removeCounter(self.activeSum)
        }
    }
}
