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
                    Rectangle().fill(.clear)
                }
                
                Button(action: { decrement() }) {
                    Rectangle().fill(.clear)
                }
            }
        } else {
            HStack(spacing: 0) {
                Button(action: {
                    if (self.orientation == .landscape) {
                        increment()
                    } else {
                        // self.orientation == .landscapeReverse
                        decrement()
                    }
                }) {
                    Rectangle().fill(.clear)
                }
                
                Button(action: {
                    if (self.orientation == .landscape) {
                        decrement()
                    } else {
                        // self.orientation == .landscapeReverse
                        increment()
                    }
                }) {
                    Rectangle().fill(.clear)
                }
            }
        }
    }
    
    func increment() -> Void {
        if (self.activeSum == .lifeTotal) {
            player.incrementLifeTotal()
        } else {
            player.addCounter(self.activeSum)
        }
    }
    
    func decrement() -> Void {
        if (self.activeSum == .lifeTotal) {
            player.decrementLifeTotal()
        } else {
            player.removeCounter(self.activeSum)
        }
    }
}
