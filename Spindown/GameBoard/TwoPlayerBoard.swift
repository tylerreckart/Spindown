//
//  TwoPlayerBoard.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/1/23.
//

import SwiftUI

enum TwoPlayerLayout {
    case facingPortrait
    case facingLandscape
    case tandem
}

struct TwoPlayerGameBoard: View {
    @Binding var players: [Participant]
    @Binding var numPlayersRemaining: Int
    
    @State var layout: TwoPlayerLayout = .facingPortrait

    var body: some View {
        if (self.layout == .facingPortrait) {
            VStack(spacing: 0) {
                PlayerTile(
                    player: $players[0],
                    color: colors[0],
                    numPlayersRemaining: $numPlayersRemaining
                )
                .rotationEffect(Angle(degrees: 180))
                PlayerTile(
                    player: $players[1],
                    color: colors[1],
                    numPlayersRemaining: $numPlayersRemaining
                )
            }
            .edgesIgnoringSafeArea(.all)
        } else if (self.layout == .facingLandscape) {
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
                .rotationEffect(Angle(degrees: 180))
            }
            .edgesIgnoringSafeArea(.all)
        } else if (self.layout == .tandem) {
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
        }
    }
}
