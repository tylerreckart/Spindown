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
    @Binding var selectedPlayer: Participant?
    @Binding var selectedLayout: BoardLayout
    var updateLifeTotal: (Participant, Int) -> Void
    var showLifeTotalCalculatorForPlayer: () -> ()
    var screenWidth = UIScreen.main.bounds.width

    var body: some View {
        if (self.players.count == 6) {
            if (self.selectedLayout == .tandem || self.selectedLayout == .facingPortrait) {
                VStack(spacing: 20) {
                    HStack(spacing: 20) {
                        PlayerTile(
                            player: players[0],
                            color: colors[0],
                            updateLifeTotal: updateLifeTotal,
                            showLifeTotalCalculator: showLifeTotalCalculatorForPlayer,
                            selectedPlayer: $selectedPlayer
                        )
                        PlayerTile(
                            player: players[1],
                            color: colors[1],
                            updateLifeTotal: updateLifeTotal,
                            showLifeTotalCalculator: showLifeTotalCalculatorForPlayer,
                            selectedPlayer: $selectedPlayer
                        )
                        PlayerTile(
                            player: players[2],
                            color: colors[2],
                            updateLifeTotal: updateLifeTotal,
                            showLifeTotalCalculator: showLifeTotalCalculatorForPlayer,
                            selectedPlayer: $selectedPlayer
                        )
                    }
                    .rotationEffect(Angle(degrees: 180))
                    HStack(spacing: 20) {
                        PlayerTile(
                            player: players[3],
                            color: colors[3],
                            updateLifeTotal: updateLifeTotal,
                            showLifeTotalCalculator: showLifeTotalCalculatorForPlayer,
                            selectedPlayer: $selectedPlayer
                        )
                        PlayerTile(
                            player: players[4],
                            color: colors[4],
                            updateLifeTotal: updateLifeTotal,
                            showLifeTotalCalculator: showLifeTotalCalculatorForPlayer,
                            selectedPlayer: $selectedPlayer
                        )
                        PlayerTile(
                            player: players[5],
                            color: colors[5],
                            updateLifeTotal: updateLifeTotal,
                            showLifeTotalCalculator: showLifeTotalCalculatorForPlayer,
                            selectedPlayer: $selectedPlayer
                        )
                    }
                }
                .edgesIgnoringSafeArea(.all)
            } else if (self.selectedLayout == .facingLandscape) {
                HStack(spacing: 20) {
                    PlayerTile(
                        player: players[0],
                        color: colors[0],
                        updateLifeTotal: updateLifeTotal,
                        orientation: .landscape,
                        showLifeTotalCalculator: showLifeTotalCalculatorForPlayer,
                        selectedPlayer: $selectedPlayer
                    )
                    .rotationEffect(Angle(degrees: 180))
                    .frame(maxWidth: screenWidth / 4)
                    VStack(spacing: 20) {
                        HStack(spacing: 20) {
                            PlayerTile(
                                player: players[1],
                                color: colors[1],
                                updateLifeTotal: updateLifeTotal,
                                showLifeTotalCalculator: showLifeTotalCalculatorForPlayer,
                                selectedPlayer: $selectedPlayer
                            )
                            PlayerTile(
                                player: players[2],
                                color: colors[2],
                                updateLifeTotal: updateLifeTotal,
                                showLifeTotalCalculator: showLifeTotalCalculatorForPlayer,
                                selectedPlayer: $selectedPlayer
                            )
                        }
                        .rotationEffect(Angle(degrees: 180))
                        HStack(spacing: 20) {
                            PlayerTile(
                                player: players[3],
                                color: colors[3],
                                updateLifeTotal: updateLifeTotal,
                                showLifeTotalCalculator: showLifeTotalCalculatorForPlayer,
                                selectedPlayer: $selectedPlayer
                            )
                            PlayerTile(
                                player: players[4],
                                color: colors[4],
                                updateLifeTotal: updateLifeTotal,
                                showLifeTotalCalculator: showLifeTotalCalculatorForPlayer,
                                selectedPlayer: $selectedPlayer
                            )
                        }
                    }
                    PlayerTile(
                        player: players[5],
                        color: colors[5],
                        updateLifeTotal: updateLifeTotal,
                        orientation: .landscape,
                        showLifeTotalCalculator: showLifeTotalCalculatorForPlayer,
                        selectedPlayer: $selectedPlayer
                    )
                    .frame(maxWidth: screenWidth / 4)
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}
