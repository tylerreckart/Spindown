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
    @Binding var selectedPlayer: Participant?
    @Binding var selectedLayout: BoardLayout
    var updateLifeTotal: (Participant, Int) -> Void
    var showLifeTotalCalculatorForPlayer: () -> ()

    var body: some View {
        if (players.count == 3) {
            if (self.selectedLayout == .facingPortrait) {
                VStack(spacing: 20) {
                    HStack(spacing: 20) {
                        PlayerTile(
                            player: players[0],
                            updateLifeTotal: updateLifeTotal,
                            showLifeTotalCalculator: showLifeTotalCalculatorForPlayer,
                            selectedPlayer: $selectedPlayer
                        )
                        PlayerTile(
                            player: players[1],
                            updateLifeTotal: updateLifeTotal,
                            showLifeTotalCalculator: showLifeTotalCalculatorForPlayer,
                            selectedPlayer: $selectedPlayer
                        )
                    }
                    .rotationEffect(Angle(degrees: 180))
                    PlayerTile(
                        player: players[2],
                        updateLifeTotal: updateLifeTotal,
                        showLifeTotalCalculator: showLifeTotalCalculatorForPlayer,
                        selectedPlayer: $selectedPlayer
                    )
                }
                .edgesIgnoringSafeArea(.all)
            } else {
                HStack(spacing: 20) {
                    PlayerTile(
                        player: players[0],
                        updateLifeTotal: updateLifeTotal,
                        showLifeTotalCalculator: showLifeTotalCalculatorForPlayer,
                        selectedPlayer: $selectedPlayer
                    )
                    PlayerTile(
                        player: players[1],
                        updateLifeTotal: updateLifeTotal,
                        showLifeTotalCalculator: showLifeTotalCalculatorForPlayer,
                        selectedPlayer: $selectedPlayer
                    )
                    PlayerTile(
                        player: players[2],
                        updateLifeTotal: updateLifeTotal,
                        showLifeTotalCalculator: showLifeTotalCalculatorForPlayer,
                        selectedPlayer: $selectedPlayer
                    )
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}
