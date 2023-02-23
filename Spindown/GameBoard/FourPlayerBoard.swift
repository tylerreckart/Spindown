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
    @Binding var selectedPlayer: Participant?
    @Binding var selectedLayout: BoardLayout
    var updateLifeTotal: (Participant, Int) -> Void
    var showLifeTotalCalculatorForPlayer: () -> ()
    var screenHeight = UIScreen.main.bounds.height

    var body: some View {
        if (self.players.count == 4) {
            if (self.selectedLayout == .tandem || self.selectedLayout == .facingPortrait) {
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
                    HStack(spacing: 20) {
                        PlayerTile(
                            player: players[2],
                            updateLifeTotal: updateLifeTotal,
                            showLifeTotalCalculator: showLifeTotalCalculatorForPlayer,
                            selectedPlayer: $selectedPlayer
                        )
                        PlayerTile(
                            player: players[3],
                            updateLifeTotal: updateLifeTotal,
                            showLifeTotalCalculator: showLifeTotalCalculatorForPlayer,
                            selectedPlayer: $selectedPlayer
                        )
                    }
                }
                .edgesIgnoringSafeArea(.all)
            } else if (self.selectedLayout == .facingLandscape) {
                VStack(spacing: 20) {
                    PlayerTile(
                        player: players[0],
                        updateLifeTotal: updateLifeTotal,
                        showLifeTotalCalculator: showLifeTotalCalculatorForPlayer,
                        selectedPlayer: $selectedPlayer
                    )
                    .rotationEffect(Angle(degrees: 180))
                    HStack(spacing: 20) {
                        PlayerTile(
                            player: players[1],
                            updateLifeTotal: updateLifeTotal,
                            orientation: .landscapeReverse,
                            showLifeTotalCalculator: showLifeTotalCalculatorForPlayer,
                            selectedPlayer: $selectedPlayer
                        )
                        PlayerTile(
                            player: players[2],
                            updateLifeTotal: updateLifeTotal,
                            orientation: .landscape,
                            showLifeTotalCalculator: showLifeTotalCalculatorForPlayer,
                            selectedPlayer: $selectedPlayer
                        )
                    }
                    PlayerTile(
                        player: players[3],
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
