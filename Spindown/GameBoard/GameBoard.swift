//
//  GameBoard.swift
//  Spindown
//
//  Created by Tyler Reckart on 1/29/23.
//

import SwiftUI

var colors: [UIColor] = [
    UIColor(named: "PrimaryPurple") ?? .systemGray,
    UIColor(named: "PrimaryBlue") ?? .systemGray,
    UIColor(named: "PrimaryGreen") ?? .systemGray,
    UIColor(named: "PrimaryYellow") ?? .systemGray,
    UIColor(named: "PrimaryOrange") ?? .systemGray,
    UIColor(named: "PrimaryRed") ?? .systemGray
]

struct GameBoard: View {
    @Binding var players: [Participant]
    @Binding var numPlayersRemaining: Int
    @Binding var activePlayer: Participant?
    
    @State private var opacity: CGFloat = 0
    @State private var scale: CGFloat = 0.75
    
    var endGame: () -> ()
    
    @State private var showSettingsDialog: Bool = false
    @State private var showLifeTotalCalculator: Bool = false
    
    @State private var selectedPlayer: Participant?
    @State private var selectedLayout: BoardLayout = .tandem
    
    var body: some View {
        ZStack {
            if (players.count == 1) {
                PlayerTile(
                    player: players[0],
                    color: colors[0],
                    updateLifeTotal: updateLifeTotal,
                    showLifeTotalCalculator: showLifeTotalCalculatorForPlayer,
                    selectedPlayer: $selectedPlayer
                )
            } else if (players.count == 2) {
                TwoPlayerGameBoard(
                    players: $players,
                    numPlayersRemaining: $numPlayersRemaining,
                    selectedPlayer: $selectedPlayer,
                    selectedLayout: $selectedLayout,
                    showLifeTotalCalculatorForPlayer: showLifeTotalCalculatorForPlayer,
                    updateLifeTotal: updateLifeTotal
                )
            } else if (players.count == 3) {
                ThreePlayerGameBoard(
                    players: $players,
                    numPlayersRemaining: $numPlayersRemaining,
                    selectedPlayer: $selectedPlayer,
                    selectedLayout: $selectedLayout,
                    updateLifeTotal: updateLifeTotal,
                    showLifeTotalCalculatorForPlayer: showLifeTotalCalculatorForPlayer
                )
            } else if (players.count == 4) {
                FourPlayerGameBoard(
                    players: $players,
                    numPlayersRemaining: $numPlayersRemaining,
                    selectedPlayer: $selectedPlayer,
                    selectedLayout: $selectedLayout,
                    updateLifeTotal: updateLifeTotal,
                    showLifeTotalCalculatorForPlayer: showLifeTotalCalculatorForPlayer
                )
            } else if (players.count == 5) {
                FivePlayerGameBoard(
                    players: $players,
                    numPlayersRemaining: $numPlayersRemaining,
                    selectedPlayer: $selectedPlayer,
                    selectedLayout: $selectedLayout,
                    updateLifeTotal: updateLifeTotal,
                    showLifeTotalCalculatorForPlayer: showLifeTotalCalculatorForPlayer
                )
            } else if (players.count == 6) {
                SixPlayerGameBoard(
                    players: $players,
                    numPlayersRemaining: $numPlayersRemaining,
                    selectedPlayer: $selectedPlayer,
                    selectedLayout: $selectedLayout,
                    updateLifeTotal: updateLifeTotal,
                    showLifeTotalCalculatorForPlayer: showLifeTotalCalculatorForPlayer
                )
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()

                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            self.showSettingsDialog.toggle()
                        }
                    }) {
                        Image(systemName: "gearshape.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.1), radius: 10)
                    }
                }
                .padding()
            }
            .edgesIgnoringSafeArea(.all)
        
            GameSettingsDialog(
                open: $showSettingsDialog,
                selectedLayout: $selectedLayout,
                players: $players,
                endGame: endGame
            )
            
            LifeTotalCalculatorDialog(
                open: $showLifeTotalCalculator,
                selectedPlayer: $selectedPlayer,
                toggleCalculator: { self.showLifeTotalCalculator.toggle() },
                updateLifeTotal: updateLifeTotal
            )
        }
        .opacity(opacity)
        .padding(10)
        .onAppear {
            // Prevent the system idle timer from putting the device's display
            // to sleep while the game board is active.
            UIApplication.shared.isIdleTimerDisabled = true
            // Custom start layout conditions.
            if (players.count == 2 || players.count == 3 || players.count == 5) {
                self.selectedLayout = .facingPortrait
            }
            // Display the game board.
            withAnimation(.easeIn(duration: 0.5)) {
                self.opacity = 1
            }
        }
        .onDisappear {
            // Re-enable the system idle timer when this view unmounts.
            UIApplication.shared.isIdleTimerDisabled = false
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

func buildTestPlayers() -> [Participant] {
    var players: [Participant] = []

    for index in 1..<3 {
        let player = Participant()
        player.name = "Player \(index)"
        player.lifeTotal = 20
        players.append(player)
    }
    
    return players
}


struct GameBoard_Previews: PreviewProvider {
    @State static var players: [Participant] = buildTestPlayers()
    @State static var numPlayersRemaining: Int = 3
    @State static var activePlayer: Participant? = buildTestPlayers()[0]
    
    static func endGame() -> Void {}
    
    static var previews: some View {
        GameBoard(
            players: $players,
            numPlayersRemaining: $numPlayersRemaining,
            activePlayer: $activePlayer,
            endGame: endGame
        ).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

