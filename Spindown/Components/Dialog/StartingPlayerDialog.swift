//
//  StartingPlayerDialog.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/1/23.
//

import SwiftUI

struct StartingPlayerDialog: View {
    @Binding var open: Bool
    @Binding var activePlayer: Participant?
    
    var startGame: () -> ()
    var chooseStartingPlayer: () -> ()
    
    var body: some View {
        Dialog(content: {
            VStack {
                VStack(spacing: 0) {
                    Text("\(activePlayer?.name ?? "")")
                        .font(.system(size: 28, weight: .black))
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 10)
                    
                    Text("Has been randomly selected to go first. Start the game or choose another starting player.")
                        .font(.system(size: 16))
                        .multilineTextAlignment(.center)
                        .lineSpacing(2)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 20)
                }
                
                VStack(spacing: 20) {
                    UIButton(
                        text: "Start Game",
                        color: UIColor(named: "PrimaryRed")!,
                        action: startGame
                    )
                    
                    UIButtonOutlined(
                        text: "Choose Another Player",
                        symbol: "arrow.clockwise",
                        fill: UIColor(named: "DeepGray")!,
                        color: UIColor(named: "AccentGray")!,
                        action: chooseStartingPlayer
                    )
                }
            }
        }, maxWidth: 300, open: $open)
    }
}
