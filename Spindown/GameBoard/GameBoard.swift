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
    
    @State private var opacity: CGFloat = 0
    @State private var scale: CGFloat = 0.75
    
    var body: some View {
        ZStack {
            if (players.count == 1) {
                PlayerTile(
                    player: $players[0],
                    color: colors[0],
                    numPlayersRemaining: $numPlayersRemaining
                )
            } else if (players.count == 2) {
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
            
            VStack {
                Spacer()
                HStack {
                    Spacer()

                    Button(action: {
                        print("render gameboard settings modal")
                    }) {
                        Image(systemName: "gearshape.circle.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.1), radius: 10)
                    }
                }
                .padding()
            }
            .edgesIgnoringSafeArea(.all)
        }
        .opacity(opacity)
        .onAppear {
            withAnimation(.easeIn(duration: 0.5)) {
                self.opacity = 1
            }
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

