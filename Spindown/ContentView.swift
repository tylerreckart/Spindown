//
//  ContentView.swift
//  Spindown
//
//  Created by Tyler Reckart on 1/29/23.
//

import SwiftUI
import CoreData

enum Page: CaseIterable {
    case home
    case lifeTotal
    case players
    case gameBoard
    
    static let page = Page.allCases
    
    var shouldShowBackButton: Bool {
        switch self {
        case .lifeTotal, .players:
            return true
        default:
            return false
        }
    }
    
    @ViewBuilder
    func view(
        setStartingLifeTotal: @escaping (Int) -> (),
        setPlayerCount: @escaping (Int) -> (),
        chooseStartingPlayer: @escaping () -> Void,
        startGame: @escaping () -> Void,
        endGame: @escaping () -> Void,
        resetBoard: @escaping () -> Void,
        showNextPage: @escaping () -> Void,
        players: Binding<[Participant]>,
        numPlayersRemaining: Binding<Int>,
        activePlayer: Binding<Participant?>,
        showStartingPlayerOverlay: Bool,
        winner: Participant?
    ) -> some View {
        switch self {
        case .home:
            SplashScreen(showNextPage: showNextPage)
        case .lifeTotal:
            StartingLifeTotalSelector(setStartingLifeTotal: setStartingLifeTotal)
        case .players:
            PlayersSelector(setNumPlayers: setPlayerCount)
        case .gameBoard:
            ZStack {
                GameBoard(
                    players: players,
                    numPlayersRemaining: numPlayersRemaining,
                    activePlayer: activePlayer,
                    endGame: endGame
                )
                
                if (winner != nil) {
                    GameOverDialog(winner: winner, resetBoard: resetBoard, endGame: endGame)
                }

                if (showStartingPlayerOverlay) {
                    StartingPlayerDialog(
                        activePlayer: activePlayer,
                        startGame: startGame,
                        chooseStartingPlayer: chooseStartingPlayer
                    )
                }
            }
        }
    }
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
    private let pages: [Page] = [.home, .lifeTotal, .players, .gameBoard]

    var body: some View {
        ForEach(pages, id: \.self) { page in
            if page == currentPage {
                page.view(
                    setStartingLifeTotal: setStartingLifeTotal,
                    setPlayerCount: setPlayerCount,
                    chooseStartingPlayer: chooseStartingPlayer,
                    startGame: startGame,
                    endGame: endGame,
                    resetBoard: resetBoard,
                    showNextPage: showNextPage,
                    players: $players,
                    numPlayersRemaining: $numPlayersRemaining,
                    activePlayer: $activePlayer,
                    showStartingPlayerOverlay: showStartOverlay,
                    winner: winner
                )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .transition(AnyTransition.scale)
            }
        }
    }
    
    private func showNextPage() {
        guard let currentIndex = pages.firstIndex(of: currentPage), pages.count > currentIndex + 1 else {
            return
        }
        currentPage = pages[currentIndex + 1]
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
        self.currentPage = .home
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
