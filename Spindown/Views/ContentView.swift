//
//  ContentView.swift
//  Spindown
//
//  Created by Tyler Reckart on 1/29/23.
//

import SwiftUI
import StoreKit

enum Page {
    case home
    case lifeTotal
    case players
    case savedPlayers
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
    
    init() {
        // If the app doesn't store the count, this returns 0.
        var count = UserDefaults.standard.integer(forKey: "sessionCount")
        count += 1
        UserDefaults.standard.set(count, forKey: "sessionCount")
        print("player session logged: \(count)")

        // Keep track of the most recent app version that prompts the user for a review.
        let lastVersionPromptedForReview = UserDefaults.standard.string(forKey: "lastReviewedVersion")

        // Get the current bundle version for the app.
        let infoDictionaryKey = kCFBundleVersionKey as String
        guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: infoDictionaryKey) as? String
            else { fatalError("Expected to find a bundle version in the info dictionary.") }
         // Verify the user completes the process several times and doesn’t receive a prompt for this app version.
         if count >= 4 && currentVersion != lastVersionPromptedForReview {
             let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
             SKStoreReviewController.requestReview(in: windowScene!)
             UserDefaults.standard.set(currentVersion, forKey: "lastReviewedVersion")
         }
    }

    var body: some View {
        switch (currentPage) {
        case .home:
            SplashScreen(showNextPage: showNextPage)
        case .lifeTotal:
            StartingLifeTotalSelector(currentPage: $currentPage, setStartingLifeTotal: setStartingLifeTotal)
        case .players:
            PlayersSelector(currentPage: $currentPage, setNumPlayers: setPlayerCount, setUsedSavedPlayers: setUsedSavedPlayers)
        case .savedPlayers:
            SavedPlayersSelector(currentPage: $currentPage, setPlayers: {})
        case .gameBoard:
            if (players.count > 0) {
                ZStack {
                    GameBoard(
                        players: $players,
                        numPlayersRemaining: $numPlayersRemaining,
                        activePlayer: $activePlayer,
                        endGame: endGame
                    )
                    
                    StartingPlayerDialog(
                        open: $showStartOverlay,
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
        withAnimation(.easeInOut(duration: 0.4)) {
            currentPage = pages[currentIndex + 1]
        }
    }
    
    private func setUsedSavedPlayers() {
        withAnimation(.easeInOut(duration: 0.4)) {
            currentPage = .savedPlayers
        }
    }
    
    private func setStartingLifeTotal(_ total: Int) -> Void {
        print("set starting life total: \(total)")
        self.startingLifeTotal = total
        showNextPage()
    }
    
    private func setPlayerCount(_ numPlayers: Int) {
        print("set player count: \(numPlayers) players")
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

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(.easeInOut(duration: 0.4)) {
                self.showStartOverlay = true
            }
        }
    }
    
    private func startGame() {
        withAnimation(.easeInOut(duration: 0.4)) {
            self.showStartOverlay = false
        }
    }
    
    private func resetBoard() {
        for player in self.players {
            player.lifeTotal = self.startingLifeTotal
        }
        
        self.winner = nil
    }
    
    private func endGame() {
        self.startingLifeTotal = 0
        self.playerCount = 0
        self.numPlayersRemaining = 0
        self.winner = nil

        withAnimation(.easeInOut(duration: 0.4)) {
            self.currentPage = .home
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.players = []
            }
        }
    }
}
