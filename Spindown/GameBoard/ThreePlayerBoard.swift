//
//  ThreePlayerBoard.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/1/23.
//

import SwiftUI

struct ThreePlayerGameBoard: View {
    @Binding var players: [Participant]
    @Binding var numPlayersRemaining: Int

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                PlayerTile(
                    player: players[0],
                    color: colors[0],
                    numPlayersRemaining: $numPlayersRemaining
                )
                PlayerTile(
                    player: players[1],
                    color: colors[1],
                    numPlayersRemaining: $numPlayersRemaining
                )
            }
            PlayerTile(
                player: players[2],
                color: colors[2],
                numPlayersRemaining: $numPlayersRemaining
            )
        }
        .edgesIgnoringSafeArea(.all)
    }
}
