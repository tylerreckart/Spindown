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
            ForEach(Array(players.enumerated()), id: \.offset) { index, player in
                if (index == 0) {
                    PlayerTile(
                        player: player,
                        color: colors[index],
                        numPlayersRemaining: $numPlayersRemaining
                    )
                } else {
                    PlayerTile(
                        player: player,
                        color: colors[index],
                        numPlayersRemaining: $numPlayersRemaining
                    )
                    .rotationEffect(Angle(degrees: 180))
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
