//
//  SixPlayerBoard.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/1/23.
//

import SwiftUI

struct SixPlayerGameBoard: View {
    @Binding var players: [Participant]
    @Binding var numPlayersRemaining: Int
    
    @Binding var selectedLayout: BoardLayout

    var body: some View {
        if (self.selectedLayout == .tandem) {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    PlayerTile(
                        player: $players[0],
                        color: colors[0],
                        numPlayersRemaining: $numPlayersRemaining
                    )
                    PlayerTile(
                        player: $players[1],
                        color: colors[1],
                        numPlayersRemaining: $numPlayersRemaining
                    )
                    PlayerTile(
                        player: $players[2],
                        color: colors[2],
                        numPlayersRemaining: $numPlayersRemaining
                    )
                }
                .rotationEffect(Angle(degrees: -180))
                HStack(spacing: 0) {
                    PlayerTile(
                        player: $players[3],
                        color: colors[3],
                        numPlayersRemaining: $numPlayersRemaining
                    )
                    PlayerTile(
                        player: $players[4],
                        color: colors[4],
                        numPlayersRemaining: $numPlayersRemaining
                    )
                    PlayerTile(
                        player: $players[5],
                        color: colors[5],
                        numPlayersRemaining: $numPlayersRemaining
                    )
                }
            }
            .edgesIgnoringSafeArea(.all)
        } else if (self.selectedLayout == .facingLandscape) {
            VStack(spacing: 0) {
                PlayerTile(
                    player: $players[0],
                    color: colors[0],
                    numPlayersRemaining: $numPlayersRemaining
                )
                HStack(spacing: 0) {
                    PlayerTile(
                        player: $players[1],
                        color: colors[1],
                        numPlayersRemaining: $numPlayersRemaining
                    )
                    PlayerTile(
                        player: $players[2],
                        color: colors[2],
                        numPlayersRemaining: $numPlayersRemaining
                    )
                }
                HStack(spacing: 0) {
                    PlayerTile(
                        player: $players[3],
                        color: colors[3],
                        numPlayersRemaining: $numPlayersRemaining
                    )
                    PlayerTile(
                        player: $players[4],
                        color: colors[4],
                        numPlayersRemaining: $numPlayersRemaining
                    )
                }
                PlayerTile(
                    player: $players[5],
                    color: colors[5],
                    numPlayersRemaining: $numPlayersRemaining
                )
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
