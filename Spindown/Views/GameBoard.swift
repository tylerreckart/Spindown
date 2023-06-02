//
//  GameBoard.swift
//  Spindown
//
//  Created by Tyler Reckart on 1/29/23.
//

import SwiftUI

var colors: [UIColor] = [
    UIColor(named: "PrimaryPurple")!,
    UIColor(named: "PrimaryBlue")!,
    UIColor(named: "PrimaryGreen")!,
    UIColor(named: "PrimaryYellow")!,
    UIColor(named: "PrimaryOrange")!,
    UIColor(named: "PrimaryRed")!
]

struct GameBoard: View {
    @EnvironmentObject var timerModel: GameTimerModel
    var store: Store

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @Binding var players: [Participant]
    @Binding var numPlayersRemaining: Int
    @Binding var activePlayer: Participant?
    @Binding var orientation: UIDeviceOrientation?
    
    var endGame: () -> ()
    
    @State private var showSettingsDialog: Bool = false
    @State private var showLifeTotalCalculator: Bool = false
    
    @State private var selectedPlayer: Participant?
    
    @State private var showSettingsSheet: Bool = false
    
    struct Pin: View {
        @Binding var showSettingsDialog: Bool
        var orientation: Orientation
        
        var trigger: some View {
            Button(action: {
                withAnimation(.spring(response: 0.55, dampingFraction: 0.5, blendDuration: 0)) {
                    self.showSettingsDialog.toggle()
                }
                
            }) {
                Image("D20")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 64)
                    .shadow(radius: 2, x: 1, y: 1)
            }
        }

        var body: some View {
            if orientation == .portrait {
                VStack {
                    Spacer()
                    trigger
                    Spacer()
                }
                .padding()
            } else {
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        trigger
                            .rotationEffect(Angle(degrees: -90))
                        Spacer()
                    }
                    Spacer()
                }
                .padding()
            }
        }
    }

    struct PlayArea: View {
        var players: [Participant]

        @Binding var selectedPlayer: Participant?
        @Binding var showSettingsDialog: Bool
        @Binding var orientation: UIDeviceOrientation?
        
        var body: some View {
            ZStack {
                VStack(spacing: 8) {
                    if (players.count == 2) {
                        PlayerTile(player: players[0], selectedPlayer: $selectedPlayer, orientation: .portrait)
                            .rotationEffect(Angle(degrees: 180))
                        PlayerTile(player: players[1], selectedPlayer: $selectedPlayer, orientation: .portrait)
                    }
                    
                    if (players.count == 3) {
                        HStack(spacing: 8) {
                            ForEach(0..<2, id: \.self) { index in
                                PlayerTile(player: players[index], selectedPlayer: $selectedPlayer, orientation: .portrait)
                                    .rotationEffect(Angle(degrees: 180))
                            }
                        }
                        
                        PlayerTile(player: players[2], selectedPlayer: $selectedPlayer, orientation: .portrait)
                    }
                    
                    if (players.count == 4) {
                        if orientation == .landscapeLeft || orientation == .landscapeRight {
                            HStack(spacing: 8) {
                                VStack(spacing: 8) {
                                    PlayerTile(player: players[0], selectedPlayer: $selectedPlayer, orientation: .landscape)
                                    PlayerTile(player: players[1], selectedPlayer: $selectedPlayer, orientation: .landscape)
                                }
                                .rotationEffect(Angle(degrees: 180))
                                
                                VStack(spacing: 8) {
                                    PlayerTile(player: players[2], selectedPlayer: $selectedPlayer, orientation: .landscape)
                                    PlayerTile(player: players[3], selectedPlayer: $selectedPlayer, orientation: .landscape)
                                }
                            }
                        } else {
                            VStack(spacing: 8) {
                                HStack(spacing: 8) {
                                    PlayerTile(player: players[0], selectedPlayer: $selectedPlayer, orientation: .portrait)
                                    PlayerTile(player: players[1], selectedPlayer: $selectedPlayer, orientation: .portrait)
                                }
                                .rotationEffect(Angle(degrees: 180))
                                
                                HStack(spacing: 8) {
                                    PlayerTile(player: players[2], selectedPlayer: $selectedPlayer, orientation: .portrait)
                                    PlayerTile(player: players[3], selectedPlayer: $selectedPlayer, orientation: .portrait)
                                }
                            }
                        }
                    }
                    
                    if (players.count == 5) {
                        HStack(spacing: 8) {
                            ForEach(0..<2, id: \.self) { row in
                                let startIndex: Int = row == 0 ? 0 : 2
                                let stopIndex:  Int = row == 0 ? 2 : 4
                                
                                VStack(spacing: 8) {
                                    ForEach(startIndex..<stopIndex, id: \.self) { index in
                                        PlayerTile(player: players[index], selectedPlayer: $selectedPlayer, orientation: .portrait)
                                            .rotationEffect(Angle(degrees: index % 2 == 0 ? 180 : 0))
                                    }
                                }
                            }
                            
                            PlayerTile(player: players[4], selectedPlayer: $selectedPlayer, orientation: .portrait)
                        }
                    }
                    
                    if (players.count == 6) {
                        HStack(spacing: 8) {
                            ForEach(0..<3, id: \.self) { row in
                                let startIndex: Int = row == 1 ? 2 : row == 2 ? 4 : 0
                                let stopIndex:  Int = row == 0 ? 2 : row == 1 ? 4 : 6
                                
                                VStack(spacing: 8) {
                                    ForEach(startIndex..<stopIndex, id: \.self) { index in
                                        PlayerTile(player: players[index], selectedPlayer: $selectedPlayer, orientation: .portrait)
                                            .rotationEffect(Angle(degrees: index % 2 == 0 ? 180 : 0))
                                    }
                                }
                            }
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Pin(
                    showSettingsDialog: $showSettingsDialog,
                    orientation: orientation == .landscapeLeft || orientation == .landscapeRight ? .landscape : .portrait
                )
            }
            .edgesIgnoringSafeArea(.all)
            .background(.black)
        }
    }
    
    var body: some View {
        ZStack {
            if (players.count > 0) {
                PlayArea(
                    players: players,
                    selectedPlayer: $selectedPlayer,
                    showSettingsDialog: $showSettingsDialog,
                    orientation: $orientation
                )
            }
        }
        .padding(0)
        .background(.black)
        .onAppear {
            // Prevent the system idle timer from putting the device's display
            // to sleep while the game board is active.
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear {
            // Re-enable the system idle timer when this view unmounts.
            UIApplication.shared.isIdleTimerDisabled = false
        }
        .onReceive(timer) { _ in
            timerModel.update()
        }
    }
    
    private func showLifeTotalCalculatorForPlayer() {
        withAnimation(.easeInOut) {
            self.showLifeTotalCalculator.toggle()
        }
    }
                 
    private func chooseNextPlayer() {
        let currentIndex = players.firstIndex(where: { $0.uid == activePlayer?.uid })
        
        if (currentIndex! + 1 >= players.count) {
            activePlayer = players[0]
        } else {
            activePlayer = players[currentIndex! + 1]
        }
    }
    
    private func updateLifeTotal(_ player: Participant, _ newLifeTotal: Int) -> Void {
        let index = self.players.firstIndex(where: { $0.name == player.name })
        
        if (index != nil) {
            print("update life total")
            player.setLifeTotal(newLifeTotal)
            
            if (newLifeTotal == 0) {
                self.numPlayersRemaining = numPlayersRemaining - 1
                print("\(player.name) lost the game")
            } else if (players[index!].lifeTotal <= 0 && newLifeTotal > 0) {
                self.numPlayersRemaining = numPlayersRemaining + 1
                print("\(player.name) re-entered the game")
            }
            
            players[index!] = player
        }
        
        self.selectedPlayer = nil
    }
}
