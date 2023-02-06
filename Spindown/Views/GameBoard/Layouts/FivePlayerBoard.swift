//
//  FivePlayerBoard.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/1/23.
//

import SwiftUI

struct FivePlayerGameBoard: View {
    @Binding var players: [Participant]
    @Binding var numPlayersRemaining: Int
    
    var updateLifeTotal: (Participant, Int) -> Void
    var showLifeTotalCalculatorForPlayer: () -> ()

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                PlayerTile(
                    player: players[0],
                    color: colors[0],
                    updateLifeTotal: updateLifeTotal,
                    showLifeTotalCalculator: showLifeTotalCalculatorForPlayer
                )
                PlayerTile(
                    player: players[1],
                    color: colors[1],
                    updateLifeTotal: updateLifeTotal,
                    showLifeTotalCalculator: showLifeTotalCalculatorForPlayer
                )
            }
            HStack(spacing: 0) {
                PlayerTile(
                    player: players[2],
                    color: colors[2],
                    updateLifeTotal: updateLifeTotal,
                    showLifeTotalCalculator: showLifeTotalCalculatorForPlayer
                )
                PlayerTile(
                    player: players[3],
                    color: colors[3],
                    updateLifeTotal: updateLifeTotal,
                    showLifeTotalCalculator: showLifeTotalCalculatorForPlayer
                )
            }
            PlayerTile(
                player: players[4],
                color: colors[4],
                updateLifeTotal: updateLifeTotal,
                showLifeTotalCalculator: showLifeTotalCalculatorForPlayer
            )
        }
        .edgesIgnoringSafeArea(.all)
    }
}
