//
//  PlayerTile.swift
//  Spindown
//
//  Created by Tyler Reckart on 1/29/23.
//

import SwiftUI

struct PlayerTile: View {
    var player: Participant
    var color: UIColor
    
    @Binding var numPlayersRemaining: Int
    
    @State private var currentLifeTotal: String = "0"
    @State private var loser: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                if (self.loser == false) {
                    Button(action: {
                        incrementLifeTotal()
                    }) {
                        Rectangle()
                            .fill(Color(color))
                            .frame(maxHeight: .infinity)
                            .cornerRadius(12)
                    }
                    
                    Button(action: {
                        decrementLifeTotal()
                    }) {
                        Rectangle()
                            .fill(Color(color))
                            .frame(maxHeight: .infinity)
                            .cornerRadius(12)
                    }
                }
            }
            
            VStack {
                Spacer()
                Text(player.name)
                    .font(.system(size: 24, weight: .regular, design: .rounded))
                if (self.loser == false) {
                    Text(currentLifeTotal)
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                } else {
                    Text("Lost")
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                }
                Spacer()
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(.white)
        .padding()
        .background(Color(color))
        .overlay(player.loser ? Color.black.opacity(0.25) : nil)
        .cornerRadius(25)
        .padding(5)
        .onAppear {
            self.currentLifeTotal = String(player.currentLifeTotal)
        }
    }
    
    func incrementLifeTotal() -> Void {
        let currentLifeTotal = player.currentLifeTotal
        let nextLifeTotal = currentLifeTotal + 1
        player.currentLifeTotal = nextLifeTotal
        print("increment life total: \(nextLifeTotal)")
        self.currentLifeTotal = String(nextLifeTotal)
    }
    
    func decrementLifeTotal() -> Void {
        let currentLifeTotal = player.currentLifeTotal
        let nextLifeTotal = currentLifeTotal - 1

        if (nextLifeTotal == 0) {
            player.loser = true
            self.loser = true
            numPlayersRemaining = numPlayersRemaining - 1
            print("\(player.name) lost the game")
        }

        player.currentLifeTotal = nextLifeTotal
        print("deccrement life total: \(nextLifeTotal)")
        self.currentLifeTotal = String(nextLifeTotal)
    }
}
