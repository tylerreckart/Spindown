//
//  FourPlayerBoard.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/1/23.
//

import SwiftUI

struct FourPlayerGameBoard: View {
    @Binding var players: [Participant]
    @Binding var numPlayersRemaining: Int
    
    @Binding var selectedLayout: BoardLayout
    
    var updateLifeTotal: (Participant, Int) -> Void
    
    var screenHeight = UIScreen.main.bounds.height

    var body: some View {
        if (self.selectedLayout == .tandem) {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    PlayerTile(
                        player: players[0],
                        color: colors[0],
                        updateLifeTotal: updateLifeTotal
                    )
                    PlayerTile(
                        player: players[1],
                        color: colors[1],
                        updateLifeTotal: updateLifeTotal
                    )
                }
                .rotationEffect(Angle(degrees: 180))
                HStack(spacing: 0) {
                    PlayerTile(
                        player: players[2],
                        color: colors[2],
                        updateLifeTotal: updateLifeTotal
                    )
                    PlayerTile(
                        player: players[3],
                        color: colors[3],
                        updateLifeTotal: updateLifeTotal
                    )
                }
            }
            .edgesIgnoringSafeArea(.all)
        } else if (self.selectedLayout == .facingLandscape) {
            VStack(spacing: 0) {
                PlayerTile(
                    player: players[0],
                    color: colors[0],
                    updateLifeTotal: updateLifeTotal
                )
                .rotationEffect(Angle(degrees: 180))
                .frame(maxHeight: screenHeight / 4)
                HStack(spacing: 0) {
                    PlayerTile(
                        player: players[1],
                        color: colors[1],
                        updateLifeTotal: updateLifeTotal,
                        orientation: .landscapeReverse
                    )
                    PlayerTile(
                        player: players[2],
                        color: colors[2],
                        updateLifeTotal: updateLifeTotal,
                        orientation: .landscape
                    )
                }
                PlayerTile(
                    player: players[3],
                    color: colors[3],
                    updateLifeTotal: updateLifeTotal
                )
                .frame(maxHeight: screenHeight / 4)
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
