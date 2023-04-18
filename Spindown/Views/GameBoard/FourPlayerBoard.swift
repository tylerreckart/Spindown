//
//  FourPlayerBoard.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/1/23.
//

import SwiftUI

struct PlayerBadges: View {
    @Binding var showOverlay: Bool

    var body: some View {
        VStack {
            HStack {
                HStack(spacing: 10) {
                    Button(action: { self.showOverlay.toggle() }) {
                        Image("XPCounterBadge")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30)
                            .shadow(radius: 2, x: 1, y: 1)
                    }
                    
                    Button(action: { self.showOverlay.toggle() }) {
                        Image("PoisonCounterBadge")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30)
                            .shadow(radius: 2, x: 1, y: 1)
                    }
                    
                    Button(action: { self.showOverlay.toggle() }) {
                        Image("EnergyCounterBadge")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30)
                            .shadow(radius: 2, x: 1, y: 1)
                    }
                    
                    Spacer()
                    
                    Image("CrownBadge")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 30)
                        .rotationEffect(Angle(degrees: 10))
                        .shadow(radius: 3)
                }
                Spacer()
            }
            .padding()
            Spacer()
        }
    }
}

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
                            showLifeTotalCalculator: showLifeTotalCalculatorForPlayer
                        )
                        .rotationEffect(Angle(degrees: 180))

                        PlayerTile(
                            player: players[1],
                            showLifeTotalCalculator: showLifeTotalCalculatorForPlayer
                        )
                        .rotationEffect(Angle(degrees: 180))
                    }

                    HStack(spacing: 8) {
                        PlayerTile(
                            player: players[2],
                            showLifeTotalCalculator: showLifeTotalCalculatorForPlayer
                        )

                        PlayerTile(
                            player: players[3],
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
                            Image("Pin")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxHeight: 60)
                                .rotationEffect(Angle(degrees: 10))
                                .shadow(radius: 3)
                        }
                    }
                }
                .padding()
            }
            .edgesIgnoringSafeArea(.all)
            .background(.black)
        }
    }
}
