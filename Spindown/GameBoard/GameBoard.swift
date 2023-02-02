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

struct GameSettingsDialog: View {
    @Binding var open: Bool
    
    var endGame: () -> ()

    @State private var overlayOpacity: CGFloat = 0
    @State private var dialogOpacity: CGFloat = 0
    @State private var dialogOffset: CGFloat = 0.75
    
    var body: some View {
        ZStack {
            Color.black.opacity(overlayOpacity)
                .onTapGesture {
                    dismissModal()
                }
            
            VStack {
                HStack(spacing: 0) {
                    Text("Settings")
                        .font(.system(size: 24, weight: .black))
                        .foregroundColor(Color.white)
                    Spacer()
                }
                
                VStack(spacing: 15) {
                    HStack(spacing: 15) {
                        UIButtonStacked(text: "Timer", symbol: "stopwatch", color: UIColor(named: "AccentGrayDarker") ?? .systemGray, action: {})
                        UIButtonStacked(text: "Roll Dice", symbol: "dice", color: UIColor(named: "AccentGrayDarker") ?? .systemGray, action: {})
                        UIButtonStacked(text: "Rules", symbol: "book", color: UIColor(named: "AccentGrayDarker") ?? .systemGray, action: {})
                    }
                    UIButtonOutlined(text: "Change Layout", symbol: "uiwindow.split.2x1", fill: .black, color: UIColor(named: "AccentGray")!, action: {})
                    UIButtonOutlined(text: "Change Format", symbol: "text.book.closed", fill: .black, color: UIColor(named: "AccentGray")!, action: {})
                    UIButtonOutlined(text: "Change Players", symbol: "person.2", fill: .black, color: UIColor(named: "AccentGray")!, action: {})
                    UIButton(text: "End Game", symbol: "xmark", color: UIColor(named: "PrimaryRed") ?? .systemGray, action: {
                        dismissModal()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            endGame()
                        }
                    })
                }
                .frame(maxWidth: 300)
            }
            .frame(maxWidth: 300)
            .padding(30)
            .background(
                Color(.black)
                    .overlay(LinearGradient(colors: [.white.opacity(0.05), .clear], startPoint: .top, endPoint: .bottom))
            )
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 15)
            .opacity(dialogOpacity)
            .scaleEffect(dialogOffset)
            .onAppear {
                withAnimation {
                    self.overlayOpacity = 0.5
                    self.dialogOpacity = 1
                    self.dialogOffset = 1.1
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation {
                            self.dialogOffset = 1
                        }
                    }
                }
            }
        }
    }
    
    func dismissModal() {
        withAnimation {
            self.overlayOpacity = 0
            self.dialogOpacity = 0
            self.dialogOffset = 0.75
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            open.toggle()
        }
    }
}


struct GameBoard: View {
    @Binding var players: [Participant]
    @Binding var numPlayersRemaining: Int
    @Binding var activePlayer: Participant?
    
    @State private var opacity: CGFloat = 0
    @State private var scale: CGFloat = 0.75
    
    var endGame: () -> ()
    
    @State private var showSettingsDialog: Bool = false
    
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
                        self.showSettingsDialog.toggle()
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
            
            if (self.showSettingsDialog == true) {
                GameSettingsDialog(open: $showSettingsDialog, endGame: endGame)
                    .edgesIgnoringSafeArea(.all)
            }
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
    
    static func endGame() -> Void {}
    
    static var previews: some View {
        GameBoard(
            players: $players,
            numPlayersRemaining: $numPlayersRemaining,
            activePlayer: $activePlayer,
            endGame: endGame
        ).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

