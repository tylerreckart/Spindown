//
//  ContentView.swift
//  Spindown
//
//  Created by Tyler Reckart on 1/29/23.
//

import SwiftUI

enum Page {
    case home
    case lifeTotal
    case players
    case gameBoard
}

struct ContentView: View {
    @State private var playerCount: Int = 0
    @State private var players: [Participant] = []
    @State private var numPlayersRemaining: Int = 0
    @State private var winner: Participant? = nil
    @State private var activePlayer: Participant?
    @State private var showStartOverlay: Bool = false
    @State private var gameBoardOpacity: CGFloat = 0
    @State private var startingLifeTotal: Int = 0
    
    @State private var currentPage: Page = .home
    var pages: [Page] = [.home, .lifeTotal, .players, .gameBoard]

    var body: some View {
        switch (currentPage) {
        case .home:
            SplashScreen(showNextPage: showNextPage)
        case .lifeTotal:
            StartingLifeTotalSelector(setStartingLifeTotal: setStartingLifeTotal)
        case .players:
            PlayersSelector(setNumPlayers: setPlayerCount)
        case .gameBoard:
            ZStack {
                GameBoard(
                    players: $players,
                    numPlayersRemaining: $numPlayersRemaining,
                    activePlayer: $activePlayer,
                    endGame: endGame
                )
                
                if (winner != nil) {
                    GameOverDialog(winner: winner, resetBoard: resetBoard, endGame: endGame)
                }

                if (showStartOverlay) {
                    StartingPlayerDialog(
                        activePlayer: $activePlayer,
                        startGame: startGame,
                        chooseStartingPlayer: chooseStartingPlayer
                    )
                }
            }
        }
    }
    
    private func showNextPage() {
        guard let currentIndex = pages.firstIndex(of: currentPage), pages.count > currentIndex + 1 else {
            return
        }
        withAnimation(.linear(duration: 0.4)) {
            currentPage = pages[currentIndex + 1]
        }
    }
    
    private func setStartingLifeTotal(_ total: Int) -> Void {
        self.startingLifeTotal = total
        showNextPage()
    }
    
    private func setPlayerCount(_ numPlayers: Int) {
        self.playerCount = numPlayers
        
        for count in 1..<numPlayers + 1 {
            let player = Participant()
            player.name = "Player \(count)"
            player.lifeTotal = self.startingLifeTotal
            player.color = colors[count - 1]
            self.players.append(player)
        }
        
        // Select the starting player.
        chooseStartingPlayer()

        self.numPlayersRemaining = numPlayers
        showNextPage()
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
            player.lifeTotal = self.startingLifeTotal
        }
        
        self.winner = nil
    }
    
    private func endGame() {
        withAnimation {
            self.currentPage = .home
        }
        self.startingLifeTotal = 0
        self.playerCount = 0
        self.numPlayersRemaining = 0
        self.winner = nil
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
