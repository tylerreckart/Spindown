//
//  GameBoard.swift
//  Spindown
//
//  Created by Tyler Reckart on 1/29/23.
//

import SwiftUI

struct GameBoard: View {
    @Binding var players: [Participant]
    @Binding var numPlayersRemaining: Int
    
    var colors: [UIColor] = [
        .systemPurple,
        .systemBlue,
        .systemGreen,
        .systemYellow,
        .systemOrange,
        .systemRed,
    ]
    
    var body: some View {
        VStack {
            ForEach(Array(players.enumerated()), id: \.offset) { index, player in
                PlayerTile(player: player, color: colors[index], numPlayersRemaining: $numPlayersRemaining)
            }
        }
        .padding([.leading, .trailing, .bottom])
    }
}
