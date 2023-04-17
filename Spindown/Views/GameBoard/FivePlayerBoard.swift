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
    @Binding var selectedPlayer: Participant?
    @Binding var selectedLayout: BoardLayout

    var updateLifeTotal: (Participant, Int) -> Void
    var showLifeTotalCalculatorForPlayer: () -> ()

    var body: some View {
        if (self.players.count == 5) {
            VStack(spacing: 20) {
                if (self.selectedLayout == .facingPortrait) {
                    HStack(spacing: 20) {
                        ForEach(0..<2, id: \.self) { index in
                            PlayerTile(
                                player: players[index],
                                showLifeTotalCalculator: showLifeTotalCalculatorForPlayer
                            )
                        }
                    }
                    .rotationEffect(Angle(degrees: 180))
                    
                    HStack(spacing: 20) {
                        ForEach(2..<5, id: \.self) { index in
                            PlayerTile(
                                player: players[index],
                                showLifeTotalCalculator: showLifeTotalCalculatorForPlayer
                            )
                        }
                    }
                } else {
                    VStack(spacing: 20) {
                        HStack(spacing: 20) {
                            ForEach(0..<2, id: \.self) { index in
                                PlayerTile(
                                    player: players[index],
                                    showLifeTotalCalculator: showLifeTotalCalculatorForPlayer
                                )
                            }
                        }
                        
                        HStack(spacing: 20) {
                            ForEach(2..<4, id: \.self) { index in
                                PlayerTile(
                                    player: players[index],
                                    showLifeTotalCalculator: showLifeTotalCalculatorForPlayer
                                )
                            }
                        }
                        
                        PlayerTile(
                            player: players[4],
                            showLifeTotalCalculator: showLifeTotalCalculatorForPlayer
                        )
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
