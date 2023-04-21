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
    
    var endGame: () -> ()
    
    @State private var showSettingsDialog: Bool = false
    @State private var showLifeTotalCalculator: Bool = false
    
    @State private var selectedPlayer: Participant?
    
    @State private var showSettingsSheet: Bool = false
    
    @State private var orientation: UIInterfaceOrientation = .landscapeLeft
    
    struct Pin: View {
        @Binding var showSettingsDialog: Bool

        var body: some View {
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
    }
    
    struct PlayArea: View {
        var players: [Participant]

        @Binding var selectedPlayer: Participant?
        @Binding var showSettingsDialog: Bool
        
        var orientation: UIInterfaceOrientation
        
        var body: some View {
            ZStack {
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        ForEach(0..<2, id: \.self) { index in
                            PlayerTile(player: players[index], selectedPlayer: $selectedPlayer, orientation: orientation)
                        }
                    }
                    
                    HStack(spacing: 8) {
                        ForEach(2..<4, id: \.self) { index in
                            PlayerTile(player: players[index], selectedPlayer: $selectedPlayer, orientation: orientation)
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Pin(showSettingsDialog: $showSettingsDialog)
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
                    orientation: orientation
                )
            }
        
            GameSettingsDialog(
                open: $showSettingsDialog,
                players: $players,
                endGame: endGame,
                store: store,
                openSettings: { self.showSettingsSheet.toggle() }
            )
            
            LifeTotalCalculatorDialog(
                open: $showLifeTotalCalculator,
                selectedPlayer: $selectedPlayer,
                toggleCalculator: { self.showLifeTotalCalculator.toggle() },
                updateLifeTotal: updateLifeTotal
            )
            
            if (self.showSettingsSheet) {
                SettingsOverlayView(open: $showSettingsSheet)
            }
        }
        .padding(0)
        .background(.black)
        .onAppear {
            // Prevent the system idle timer from putting the device's display
            // to sleep while the game board is active.
            UIApplication.shared.isIdleTimerDisabled = true
            
            if (UIDevice.current.orientation.isLandscape) {
                self.orientation = .landscapeLeft
            } else {
                self.orientation = .portrait
            }
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
