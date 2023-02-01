//
//  TwoPlayerBoard.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/1/23.
//

import SwiftUI

struct TwoPlayerGameBoard: View {
    @Binding var players: [Participant]
    @Binding var numPlayersRemaining: Int

    var body: some View {
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
        }
        .edgesIgnoringSafeArea(.all)
    }
}
