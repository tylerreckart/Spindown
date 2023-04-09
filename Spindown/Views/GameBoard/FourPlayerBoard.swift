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
    @Binding var showSettingsDialog: Bool

    var body: some View {
        if (self.players.count == 4) {
            ZStack {
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        PlayerTile(
                            player: players[0],
                            updateLifeTotal: updateLifeTotal,
                            orientation: .landscape,
                            showLifeTotalCalculator: showLifeTotalCalculatorForPlayer,
                            selectedPlayer: $selectedPlayer
                        )
                        .cornerRadius(16, corners: [.bottomRight])
                        .shadow(color: .black.opacity(0.8), radius: 4)

                        PlayerTile(
                            player: players[1],
                            updateLifeTotal: updateLifeTotal,
                            orientation: .landscapeReverse,
                            showLifeTotalCalculator: showLifeTotalCalculatorForPlayer,
                            selectedPlayer: $selectedPlayer
                        )
                        .cornerRadius(16, corners: [.bottomLeft])
                        .shadow(color: .black.opacity(0.8), radius: 4)
                    }

                    HStack(spacing: 8) {
                        PlayerTile(
                            player: players[2],
                            updateLifeTotal: updateLifeTotal,
                            orientation: .landscape,
                            showLifeTotalCalculator: showLifeTotalCalculatorForPlayer,
                            selectedPlayer: $selectedPlayer,
                            top: true
                        )
                        .cornerRadius(16, corners: [.topRight])
                        .shadow(color: .black.opacity(0.8), radius: 4)
                    
                        PlayerTile(
                            player: players[3],
                            updateLifeTotal: updateLifeTotal,
                            orientation: .landscapeReverse,
                            showLifeTotalCalculator: showLifeTotalCalculatorForPlayer,
                            selectedPlayer: $selectedPlayer,
                            top: true
                        )
                        .cornerRadius(16, corners: [.topLeft])
                        .shadow(color: .black.opacity(0.8), radius: 4)
                    }
                }
                .edgesIgnoringSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                VStack {
                    Button(action: {
                        withAnimation(.spring(response: 0.55, dampingFraction: 0.5, blendDuration: 0)) {
                            self.showSettingsDialog.toggle()
                        }
                        
                    }) {
                        Image("Pin")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 60)
                            .rotationEffect(Angle(degrees: 82))
                            .shadow(radius: 4)
                    }
                    Spacer()
                }
                .padding(.top, 54)
            }
            .edgesIgnoringSafeArea(.all)
            .background(
                Image("Table")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
            )
        }
    }
}
