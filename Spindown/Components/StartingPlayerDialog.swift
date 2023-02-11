//
//  StartingPlayerDialog.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/1/23.
//

import SwiftUI

struct StartingPlayerDialog: View {
    @Binding var activePlayer: Participant?
    
    var startGame: () -> ()
    var chooseStartingPlayer: () -> ()
    
    @State private var overlayOpacity: CGFloat = 0
    @State private var dialogOpacity: CGFloat = 0
    @State private var dialogOffset: CGFloat = 0.75
    
    var body: some View {
        ZStack {
            Color.black.opacity(overlayOpacity)
            
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
                
                VStack {
                    UIButton(text: "Start Game", color: UIColor(named: "PrimaryRed") ?? .systemGray, action: dismissModal)
                        .padding(.bottom, 5)
                    UIButtonOutlined(text: "Choose Another Player", symbol: "arrow.clockwise", fill: .black, color: UIColor(named: "AccentGray") ?? .systemGray, action: chooseStartingPlayer)
                }
            }
            .frame(maxWidth: 300)
            .padding(30)
            .background(Color(.black))
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
            startGame()
        }
    }
}
