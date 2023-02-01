//
//  GameBoard.swift
//  Spindown
//
//  Created by Tyler Reckart on 1/29/23.
//

import SwiftUI

var colors: [UIColor] = [
    .systemPurple,
    .systemBlue,
    .systemGreen,
    .systemYellow,
    .systemOrange,
    .systemPink,
]

struct GameBoard: View {
    @Binding var players: [Participant]
    @Binding var numPlayersRemaining: Int
    @Binding var activePlayer: Participant?
    
    var body: some View {
        ZStack {
            if (players.count > 0) {
                if (players.count == 2) {
                    TwoPlayerGameBoard(players: $players, numPlayersRemaining: $numPlayersRemaining)
                } else if (players.count == 3) {
                    ThreePlayerGameBoard(players: $players, numPlayersRemaining: $numPlayersRemaining)
                } else if (players.count == 4) {
                    FourPlayerGameBoard(players: $players, numPlayersRemaining: $numPlayersRemaining)
                } else if (players.count == 5) {
                    FivePlayerGameBoard(players: $players, numPlayersRemaining: $numPlayersRemaining)
                } else if (players.count == 6) {
                    SixPlayerGameBoard(players: $players, numPlayersRemaining: $numPlayersRemaining)
                }
            }
        }
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global).onEnded({ value in chooseNextPlayer() }))
        .onAppear {
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
            AppDelegate.orientationLock = .landscapeLeft
        }.onDisappear {
            AppDelegate.orientationLock = .all
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
}

func buildTestPlayers() -> [Participant] {
    var players: [Participant] = []

    for index in 1..<3 {
        let player = Participant()
        player.name = "Player \(index)"
        player.currentLifeTotal = 20
        players.append(player)
    }
    
    return players
}


struct GameBoard_Previews: PreviewProvider {
    @State static var players: [Participant] = buildTestPlayers()
    @State static var numPlayersRemaining: Int = 3
    @State static var activePlayer: Participant? = buildTestPlayers()[0]
    
    static var previews: some View {
        GameBoard(
            players: $players,
            numPlayersRemaining: $numPlayersRemaining,
            activePlayer: $activePlayer
        ).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

