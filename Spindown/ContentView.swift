//
//  ContentView.swift
//  Spindown
//
//  Created by Tyler Reckart on 1/29/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var playerCount: Int = 0
    @State private var format: Format? = nil
    @State private var setupStep: Int = 0
    @State private var setupComplete: Bool = false
    @State private var players: [Participant] = []
    @State private var numPlayersRemaining: Int = 0
    @State private var winner: Participant? = nil
    @State private var activePlayer: Participant?
    @State private var showStartOverlay: Bool = false
    // Next turn overlay.
    @State private var turnCount: Int = 0
    @State private var showNextTurnOverlay: Bool = false
    
    var body: some View {
        ZStack {
            if (self.setupComplete == false) {
                if (self.setupStep == 0) {
                    VStack {
                        Spacer()
                        
                        UIButton(text: "Setup Game", symbol: nil, color: .systemBlue, action: { self.setupStep += 1 })

                        Spacer()
                    }
                }
                
                if (self.setupStep == 1) {
                    FormatSelector(setupStep: $setupStep, setFormat: selectFormat)
                }
                
                if (self.setupStep == 2) {
                    PlayerSelector(setupStep: $setupStep, setNumPlayers: selectPlayerCount)
                }
            }
            
            if (self.setupComplete) {
                ZStack {
                    GameBoard(players: $players, numPlayersRemaining: $numPlayersRemaining, activePlayer: $activePlayer)
                    
                    if (self.winner != nil) {
                        WinnerDialog(winner: winner, resetBoard: resetBoard, endGame: endGame)
                    }
                }
            }
            
            if (self.showStartOverlay == true) {
                StartingPlayerOverlay(
                    activePlayer: $activePlayer,
                    startGame: startGame,
                    chooseStartingPlayer: chooseStartingPlayer
                )
            }
        }
        .onChange(of: setupStep) { newState in
            print("setup step change handler")
            if (setupStep == 3) {
                // Reset state for future game setup.
                self.setupStep = 0
                // Set completion state for board draw.
                self.setupComplete = true
            }
        }
        .onChange(of: setupComplete) { newState in
            print("setup completion change handler")
            if (self.setupComplete == true && self.players.count == 0) {
                for count in 1..<self.playerCount + 1 {
                    let player = Participant()
                    player.name = "Player \(count)"
                    player.currentLifeTotal = format?.startingLifeTotal ?? 20
                    self.players.append(player)
                }
                
                // Select the starting player.
                chooseStartingPlayer()
            } else {
                self.players = []
            }

            self.numPlayersRemaining = self.players.count
        }
        .onChange(of: numPlayersRemaining) { newState in
            if (newState == 1 && players.count != 1) {
                let winningPlayer = self.players.filter { $0.loser != true }
                
                if (winningPlayer.count > 0) {
                    self.winner = winningPlayer[0]
                }
            } else if (newState == 0 && players.count == 1) {
                let winningPlayer = self.players[0]
                self.winner = winningPlayer
            }
        }
        .onChange(of: activePlayer) { newState in
            if (self.showStartOverlay != true) {
                self.turnCount += 1
                self.showNextTurnOverlay = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    print("NextTurnOverlay async dismiss from ContentView")
                    self.showNextTurnOverlay = false
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    private func selectFormat(_ selectedFormat: Format) -> Void {
        if (self.format == nil) {
            self.format = selectedFormat
        } else {
            self.format!.name = selectedFormat.name
            self.format!.startingLifeTotal = selectedFormat.startingLifeTotal
        }
    }
    
    private func selectPlayerCount(_ numPlayers: Int) {
        self.playerCount = numPlayers
    }
    
    private func chooseStartingPlayer() {
        self.activePlayer = self.players.randomElement()
        self.showStartOverlay = true
    }
    
    private func startGame() {
        self.showStartOverlay = false
    }
    
    private func resetBoard() {
        let remappedPlayers = players.map { (player: Participant) -> Participant in
            let mutableplayer = player
            mutableplayer.currentLifeTotal = format?.startingLifeTotal ?? 20
            mutableplayer.loser = false
            return mutableplayer
        }

        self.players = []
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
            self.players = remappedPlayers
            self.playerCount = remappedPlayers.count
            self.numPlayersRemaining = remappedPlayers.count
            self.winner = nil
        }
    }
    
    private func endGame() {
        // Reset game state.
        self.setupComplete = false
        self.format = nil
        self.players = []
        self.playerCount = 0
        self.numPlayersRemaining = 0
        self.winner = nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
