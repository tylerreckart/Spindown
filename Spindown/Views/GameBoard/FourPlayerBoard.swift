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
        ZStack {
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    PlayerTile(
                        player: players[0],
                        selectedPlayer: $selectedPlayer,
                        showLifeTotalCalculator: showLifeTotalCalculatorForPlayer
                    )
                    .rotationEffect(Angle(degrees: 180))

                    PlayerTile(
                        player: players[1],
                        selectedPlayer: $selectedPlayer,
                        showLifeTotalCalculator: showLifeTotalCalculatorForPlayer
                    )
                    .rotationEffect(Angle(degrees: 180))
                }

                HStack(spacing: 8) {
                    PlayerTile(
                        player: players[2],
                        selectedPlayer: $selectedPlayer,
                        showLifeTotalCalculator: showLifeTotalCalculatorForPlayer
                    )

                    PlayerTile(
                        player: players[3],
                        selectedPlayer: $selectedPlayer,
                        showLifeTotalCalculator: showLifeTotalCalculatorForPlayer
                    )
                }
            }
            .edgesIgnoringSafeArea(.all)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            HStack {
                Spacer()

                VStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.spring(response: 0.55, dampingFraction: 0.5, blendDuration: 0)) {
                            self.showSettingsDialog.toggle()
                        }
                        
                    }) {
                        Image("D20")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 60)
                            .rotationEffect(Angle(degrees: 10))
                            .shadow(radius: 2, x: 1, y: 1)
                    }
                }
            }
            .padding()
        }
        .edgesIgnoringSafeArea(.all)
        .background(.black)
    }
}
