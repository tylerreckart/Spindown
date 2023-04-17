//
//  FourPlayerBoard.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/1/23.
//

import SwiftUI

struct PlayerBadges: View {
    var body: some View {
        VStack {
            HStack {
                HStack(spacing: 10) {
                    Image("XPCounterBadge")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30)
                        .shadow(radius: 2, x: 1, y: 1)
                    
                    Image("PoisonCounterBadge")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30)
                        .shadow(radius: 2, x: 1, y: 1)
                    
                    Image("EnergyCounterBadge")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30)
                        .shadow(radius: 2, x: 1, y: 1)
                    
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
                        ZStack {
                            PlayerTile(
                                player: players[0],
                                updateLifeTotal: updateLifeTotal,
                                orientation: .landscape,
                                showLifeTotalCalculator: showLifeTotalCalculatorForPlayer,
                                selectedPlayer: $selectedPlayer
                            )
                            
                            PlayerBadges()
                        }
                        .rotationEffect(Angle(degrees: 180))

                        ZStack {
                            PlayerTile(
                                player: players[1],
                                updateLifeTotal: updateLifeTotal,
                                orientation: .landscapeReverse,
                                showLifeTotalCalculator: showLifeTotalCalculatorForPlayer,
                                selectedPlayer: $selectedPlayer
                            )
                            
                            PlayerBadges()
                                .padding(.leading, 32)
                        }
                        .rotationEffect(Angle(degrees: 180))
                    }

                    HStack(spacing: 8) {
                        ZStack {
                            PlayerTile(
                                player: players[2],
                                updateLifeTotal: updateLifeTotal,
                                orientation: .landscape,
                                showLifeTotalCalculator: showLifeTotalCalculatorForPlayer,
                                selectedPlayer: $selectedPlayer
                            )
                            
                            PlayerBadges()
                        }
                    
                        ZStack {
                            PlayerTile(
                                player: players[3],
                                updateLifeTotal: updateLifeTotal,
                                orientation: .landscapeReverse,
                                showLifeTotalCalculator: showLifeTotalCalculatorForPlayer,
                                selectedPlayer: $selectedPlayer
                            )
                            
                            PlayerBadges()
                                .padding(.trailing, 28)
                        }
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
//            .background(
//                LinearGradient(
//                    colors: [
//                        Color(hex: "DB3B5C"),
//                        Color(hex: "FFF067"),
//                        Color(hex: "B0DE8C"),
//                        Color(hex: "7362A5")
//                    ],
//                    startPoint: .top,
//                    endPoint: .bottom
//                )
//                .overlay(.thickMaterial)
//            )
        }
    }
}
