//
//  TwoPlayerBoard.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/1/23.
//

import SwiftUI

enum BoardLayout {
    case facingPortrait
    case facingLandscape
    case tandem
}

struct TwoPlayerGameBoard: View {
    @Binding var players: [Participant]
    @Binding var numPlayersRemaining: Int
    @Binding var selectedPlayer: Participant?
    @Binding var selectedLayout: BoardLayout
    var showLifeTotalCalculatorForPlayer: () -> ()
    
    var updateLifeTotal: (Participant, Int) -> Void

    var body: some View {
        if (self.selectedLayout == .facingPortrait) {
            VStack(spacing: 20) {
                PlayerTile(
                    player: players[0],
                    color: colors[0],
                    updateLifeTotal: updateLifeTotal,
                    showLifeTotalCalculator: showLifeTotalCalculatorForPlayer,
                    selectedPlayer: $selectedPlayer
                )
                .rotationEffect(Angle(degrees: 180))
                PlayerTile(
                    player: players[1],
                    color: colors[1],
                    updateLifeTotal: updateLifeTotal,
                    showLifeTotalCalculator: showLifeTotalCalculatorForPlayer,
                    selectedPlayer: $selectedPlayer
                )
            }
            .edgesIgnoringSafeArea(.all)
        } else if (self.selectedLayout == .facingLandscape) {
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
                .rotationEffect(Angle(degrees: 180))
            }
            .edgesIgnoringSafeArea(.all)
        } else if (self.selectedLayout == .tandem) {
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
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
