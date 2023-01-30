//
//  WinnerDialog.swift
//  Spindown
//
//  Created by Tyler Reckart on 1/29/23.
//

import SwiftUI

struct WinnerDialog: View {
    var winner: Participant?

    var resetBoard: () -> ()
    var endGame: () -> ()

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
            
            VStack(spacing: 0) {
                Text("\(winner!.name) won the game!")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .padding(.bottom, 25)
                
                HStack {
                    Button(action: { resetBoard() }) {
                        Text("Play Again")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(.white))
                            .frame(maxWidth: 160)
                            .padding()
                            .background(Color(.systemBlue))
                            .cornerRadius(8)
                    }
                    
                    Spacer()
                    
                    Button(action: { endGame() }) {
                        Text("End Game")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(.white))
                            .frame(maxWidth: 160)
                            .padding()
                            .background(Color(.systemRed))
                            .cornerRadius(8)
                    }
                }
            }
            .frame(maxWidth: 400)
            .padding(30)
            .background(Color(.systemGray6))
            .cornerRadius(25)
            .shadow(color: Color.black.opacity(0.25), radius: 20)
        }
        .edgesIgnoringSafeArea(.all)
    }
}
