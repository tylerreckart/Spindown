//
//  ContentView.swift
//  Spindown
//
//  Created by Tyler Reckart on 1/29/23.
//

import SwiftUI
import CoreData

struct Toolbar: View {
    var activePlayer: Participant?
    var hours: Int
    var minutes: Int
    var seconds: Int

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "person.crop.circle")
                Text("\(activePlayer?.name ?? "")'s Turn")
                    .foregroundColor(Color(.white))
            }
            .padding(.trailing, 10)
    
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
        .foregroundColor(Color(.systemBlue))
        .padding()
        .padding([.leading, .trailing])
    }
}

struct StartingPlayerOverlay: View {
    @Binding var activePlayer: Participant?
    
    var startGame: () -> ()
    var chooseStartingPlayer: () -> ()
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.9)
            
            VStack {
                Image(systemName: "person.crop.circle")
                    .font(.system(size: 64))
                    .padding(.bottom, 5)
                Text("\(activePlayer?.name ?? "")")
                    .font(.system(size: 48, weight: .black))
                    .padding(.bottom, 5)
                Text("Has been randomly chosen to go first.")
                    .padding(.bottom)
                
                VStack {
                    Button(action: {
                        startGame()
                    }) {
                        Text("Start Game")
                            .font(.system(size: 16, weight: .black))
                            .foregroundColor(Color(.white))
                            .frame(maxWidth: 250)
                            .padding()
                            .background(Color(.systemBlue))
                            .cornerRadius(12)
                    }
                    .padding(.bottom, 5)

                    Button(action: {
                        chooseStartingPlayer()
                    }) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Choose Another Player")
                        }
                        .font(.system(size: 16, weight: .black))
                        .foregroundColor(Color(.white))
                        .frame(maxWidth: 250)
                        .padding()
                        .background(Color(.systemPink))
                        .cornerRadius(12)
                    }
                }
            }
        }
    }
}

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
                            Toolbar(
                                activePlayer: self.activePlayer,
                                hours: hours,
                                minutes: minutes,
                                seconds: seconds
                            )
                        }
                        GameBoard(players: $players, numPlayersRemaining: $numPlayersRemaining, activePlayer: $activePlayer)
                    }
                    
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
        
        _ = timer
    }
    
    private func resetTimer() {
        timer.invalidate()
        self.timeElapsed = 0
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
            resetTimer()
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
        resetTimer()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
