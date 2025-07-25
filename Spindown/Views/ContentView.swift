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
    @AppStorage("isSubscribed") private var currentEntitlement: Bool = false
    @StateObject var store: Store = Store()
    
    var pages: [Page] = [.home, .lifeTotal, .players, .gameBoard]
    
    // Initialize global timer.
    @StateObject var timerModel = GameTimerModel()
    // Current board state.
    @State private var currentPage: Page = .home
    @State private var playerCount: Int = 0
    @State private var players: [Participant] = []
    @State private var numPlayersRemaining: Int = 0
    @State private var activePlayer: Participant?
    @State private var startingLifeTotal: Int = 0
    // Display.
    @State private var showStartOverlay: Bool = false
    @State private var gameBoardOpacity: CGFloat = 0
    // Sheets.
    @State private var showOnboardingSheet: Bool = false
    
    var body: some View {
        ZStack {
            switch (currentPage) {
            case .home:
                SplashScreen(showNextPage: showNextPage, store: store)
            case .lifeTotal:
                StartingLifeTotalSelector(currentPage: $currentPage, setStartingLifeTotal: setStartingLifeTotal)
            case .players:
                PlayersSelector(currentPage: $currentPage, setNumPlayers: setPlayerCount, setUsedSavedPlayers: setUsedSavedPlayers)
            case .savedPlayers:
                SavedPlayersSelector(
                    currentPage: $currentPage,
                    startingLifeTotal: $startingLifeTotal,
                    players: $players,
                    startGame: chooseAndAdvance
                )
            case .gameBoard:
                if (players.count > 0) {
                    ZStack {
                        GameBoard(
                            store: store,
                            players: $players,
                            numPlayersRemaining: $numPlayersRemaining,
                            activePlayer: $activePlayer,
                            endGame: endGame
                        )
                        .environmentObject(timerModel)
                        
                        StartingPlayerDialog(
                            open: $showStartOverlay,
                            activePlayer: $activePlayer,
                            startGame: startGame,
                            chooseStartingPlayer: chooseStartingPlayer
                        )
                        
                        OutOfTimeDialog(
                            open: $timerModel.showDialog,
                            endGame: endGame,
                            dismiss: timerModel.reset
                        )
                    }
                }
            }
        }
        .sheet(isPresented: $showOnboardingSheet) {
            SubscriptionView(store: store)
        }
        .onChange(of: store.initialized) { _ in
            Task {
                await checkPlayerEntitlements()
            }
        }
    }
    
    private func checkPlayerEntitlements() async -> Void {
        if (store.subscriptions.isEmpty) {
            return
        }

        if (store.purchasedSubscriptions.isEmpty) {
            self.currentEntitlement = false
            return
        }

        let sub = store.purchasedSubscriptions[0]
        let status = try? await sub.subscription?.status[0] ?? nil
        
        if (status != nil) {
            print(status!.state.localizedDescription)
            if (status!.state == .expired && (status!.state != .inGracePeriod || status!.state != .inBillingRetryPeriod)) {
                self.currentEntitlement = false
                return
            }
            
            if (status!.state == .revoked) {
                self.currentEntitlement = false
                return
            }
            
            if (currentEntitlement == false) {
                self.currentEntitlement = true
            }
        }
    }
    
    private func showNextPage() {
        if (self.currentPage == .savedPlayers) {
            withAnimation(.easeInOut(duration: 0.4)) {
                currentPage = .gameBoard
            }
        } else {
            guard let currentIndex = pages.firstIndex(of: currentPage), pages.count > currentIndex + 1 else {
                return
            }
            withAnimation(.easeInOut(duration: 0.4)) {
                currentPage = pages[currentIndex + 1]
            }
        }
    }
    
    private func setUsedSavedPlayers() {
        if (self.currentEntitlement) {
            withAnimation(.easeInOut(duration: 0.4)) {
                currentPage = .savedPlayers
            }
        } else {
            self.showOnboardingSheet.toggle()
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
        
        chooseAndAdvance()
    }
    
    func chooseAndAdvance() {
        // Select the starting player.
        chooseStartingPlayer()
        self.numPlayersRemaining = self.playerCount
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
    }
    
    private func endGame() {
        self.startingLifeTotal = 0
        self.playerCount = 0
        self.numPlayersRemaining = 0

        withAnimation(.easeInOut(duration: 0.4)) {
            self.currentPage = .home
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.players = []
            }
        }
    }
}
