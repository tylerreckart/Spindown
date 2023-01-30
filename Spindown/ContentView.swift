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
    
    @State var timeElapsed: Int = 0

    var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            timeElapsed += 1
        }
    }

    var hours: Int {
      timeElapsed / 3600
    }

    var minutes: Int {
      (timeElapsed % 3600) / 60
    }

    var seconds: Int {
      timeElapsed % 60
    }
    
    var body: some View {
        ZStack {
            if (self.setupComplete == false) {
                if (self.setupStep == 0) {
                    VStack {
                        Spacer()
                        
                        if (self.setupStep == 0) {
                            Button(action: {
                                self.setupStep += 1
                            }) {
                                Text("Start Game")
                            }
                        }
                        
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
                    VStack(spacing: 0) {
                        if (self.players.count > 0) {
                            HStack {
                                HStack {
                                    Image(systemName: "person.2.fill")
                                    Text("\(playerCount)")
                                        .foregroundColor(Color(.white))
                                }
                                .padding(.trailing, 5)
                            
                                HStack {
                                    Image(systemName: "menucard.fill")
                                    Text("\(format?.name ?? "")")
                                        .foregroundColor(Color(.white))
                                }
                                .padding(.trailing, 5)
                                
                                HStack {
                                    Image(systemName: "clock.fill")
                                    Text("\(hours < 10 ? "0\(hours)" : "\(hours)"):\(minutes < 10 ? "0\(minutes)" : "\(minutes)"):\(seconds < 10 ? "0\(seconds)" : "\(seconds)")")
                                        .foregroundColor(Color(.white))
                                }
                                
                                Spacer()
                                
                                HStack {
                                    Image(systemName: "gearshape.fill")
                                    Text("Settings")
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .foregroundColor(Color(.systemBlue))
                            .frame(height: 50)
                            .cornerRadius(25)
                            .padding()
                        }
                        
                        GameBoard(players: $players, numPlayersRemaining: $numPlayersRemaining)
                    }
                    
                    if (self.winner != nil) {
                        WinnerDialog(winner: winner, resetBoard: resetBoard, endGame: endGame)
                    }
                }
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
