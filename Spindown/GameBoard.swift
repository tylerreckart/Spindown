//
//  GameBoard.swift
//  Spindown
//
//  Created by Tyler Reckart on 1/29/23.
//

import SwiftUI

struct GameBoard: View {
    @Binding var players: [Participant]
    @Binding var numPlayersRemaining: Int
    @Binding var activePlayer: Participant?
    
    var colors: [UIColor] = [
        .systemPurple,
        .systemBlue,
        .systemGreen,
        .systemYellow,
        .systemOrange,
        .systemPink,
    ]
    
    var body: some View {
        ZStack {
            HStack {
                ForEach(Array(players.enumerated()), id: \.offset) { index, player in
                    PlayerTile(
                        player: player,
                        color: colors[index],
                        numPlayersRemaining: $numPlayersRemaining
                    )
                }
            }
        }
        .padding([.leading, .trailing, .bottom])
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onEnded({ value in chooseNextPlayer() }))
            
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
