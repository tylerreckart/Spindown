//
//  GameOverDialog.swift
//  Spindown
//
//  Created by Tyler Reckart on 1/29/23.
//

import SwiftUI

struct GameOverDialog: View {
    var winner: Participant?

    var resetBoard: () -> ()
    var endGame: () -> ()
    
    @State private var overlayOpacity: CGFloat = 0
    @State private var dialogOpacity: CGFloat = 0
    @State private var dialogOffset: CGFloat = 0.75

    var body: some View {
        ZStack {
            Color.black.opacity(overlayOpacity)
            
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    Text("\(winner!.name) won the game!")
                        .font(.system(size: 24, weight: .black))
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 5)

                    Text("Challenge your opponents to a rematch or return to the home screen by ending the game.")
                        .font(.system(size: 16))
                        .multilineTextAlignment(.center)
                        .lineSpacing(2)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 25)
                }
                .frame(maxWidth: 350)
                
                VStack {
                    UIButton(text: "Play Again", symbol: "arrow.clockwise", color: UIColor(named: "PrimaryRed") ?? .systemGray, action: reset)
                        .padding(.bottom, 5)
                    UIButtonOutlined(text: "End Game", symbol: "xmark", fill: .black, color: UIColor(named: "AccentGray") ?? .systemGray, action: end)
                }
            }
            .frame(maxWidth: 300)
            .padding(30)
            .background(Color(.black))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 15)
            .opacity(dialogOpacity)
            .scaleEffect(dialogOffset)
        }
        .edgesIgnoringSafeArea(.all)
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
    
    func end() -> Void {
        withAnimation {
            self.overlayOpacity = 0
            self.dialogOpacity = 0
            self.dialogOffset = 0.75
        }
        
        endGame()
    }
    
    func reset() -> Void {
        withAnimation {
            self.overlayOpacity = 0
            self.dialogOpacity = 0
            self.dialogOffset = 0.75
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            resetBoard()
        }
    }
}
