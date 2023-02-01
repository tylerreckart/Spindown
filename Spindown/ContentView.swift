//
//  ContentView.swift
//  Spindown
//
//  Created by Tyler Reckart on 1/29/23.
//

import SwiftUI
import CoreData

struct Hexagon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.size.height, rect.size.width) / 2
        let corners = corners(center: center, radius: radius)
        path.move(to: corners[0])
        corners[1...5].forEach() { point in
            path.addLine(to: point)
        }
        path.closeSubpath()
        return path
    }

    func corners(center: CGPoint, radius: CGFloat) -> [CGPoint] {
        var points: [CGPoint] = []
        for i in (0...5) {
          let angle = CGFloat.pi / 3 * CGFloat(i)
          let point = CGPoint(
            x: center.x + radius * cos(angle),
            y: center.y + radius * sin(angle)
          )
          points.append(point)
        }
        return points
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
    @State private var gameBoardOpacity: CGFloat = 0
    
    var body: some View {
        ZStack {
            if (self.setupComplete == false) {
                if (self.setupStep == 0) {
                    VStack {
                        Spacer()
                        
                        UIButton(text: "Setup Game", symbol: nil, color: .systemBlue, action: { self.setupStep += 1 })

                        Spacer()
                    }
                    .frame(maxWidth: 280)
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
                        .opacity(gameBoardOpacity)
                    
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

                withAnimation {
                    self.gameBoardOpacity = 1
                }
            }
        }
        .onChange(of: setupComplete) { newState in
            print("setup completion change handler")
            if (self.setupComplete == true && self.players.count == 0) {
                for count in 1..<self.playerCount + 1 {
                    let player = Participant()
                    player.name = "Player \(count)"
                    player.currentLifeTotal = format?.startingLifeTotal ?? 20
                    player.color = colors[count - 1]
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
        
        withAnimation(.easeIn(duration: 0.5)) {
            self.showStartOverlay = true
        }
    }
    
    private func startGame() {
        self.showStartOverlay = false
    }
    
    private func resetBoard() {
        for player in self.players {
            player.currentLifeTotal = format?.startingLifeTotal ?? 20
            player.loser = false
        }
        
        self.winner = nil
    }
    
    private func endGame() {
        withAnimation {
            self.gameBoardOpacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.setupComplete = false
            self.format = nil
            self.playerCount = 0
            self.numPlayersRemaining = 0
            self.winner = nil
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
