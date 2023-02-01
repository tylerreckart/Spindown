//
//  WinnerDialog.swift
//  Spindown
//
//  Created by Tyler Reckart on 1/29/23.
//

import SwiftUI

struct UIButton: View {
    var text: String
    var symbol: String?
    var color: UIColor
    var action: () -> ()

    var body: some View {
        Button(action: { action() }) {
            HStack {
                if (symbol != nil) {
                    Image(systemName: symbol!)
                }
                Text(text)
            }
            .font(.system(size: 16, weight: .black))
            .foregroundColor(Color(.white))
            .frame(maxWidth: 160)
            .padding()
            .background(Color(color))
            .cornerRadius(12)
        }
    }
}

struct WinnerDialog: View {
    var winner: Participant?

    var resetBoard: () -> ()
    var endGame: () -> ()
    
    
    @State private var overlayOpacity: CGFloat = 0
    @State private var dialogOpacity: CGFloat = 0
    @State private var dialogOffset: CGFloat = 50

    var body: some View {
        ZStack {
            Color.black.opacity(overlayOpacity)
            
            VStack(spacing: 0) {
                Text("\(winner!.name) won the game!")
                    .font(.system(size: 28, weight: .bold))
                    .padding(.bottom, 25)
                
                HStack {
                    UIButton(text: "Play Again", symbol: "arrow.clockwise", color: .systemBlue, action: reset)
                    Spacer()
                    UIButton(text: "End Game", symbol: "xmark", color: .systemPink, action: end)
                }
            }
            .frame(maxWidth: 400)
            .padding(30)
            .background(Color(.systemGray6))
            .cornerRadius(25)
            .shadow(color: Color.black.opacity(0.25), radius: 20)
            .opacity(dialogOpacity)
            .offset(y: dialogOffset)
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            withAnimation {
                self.overlayOpacity = 0.4
                self.dialogOpacity = 1
                self.dialogOffset = 0
            }
        }
        .onDisappear {
        }
    }
    
    func end() -> Void {
        withAnimation {
            self.overlayOpacity = 0
            self.dialogOpacity = 0
            self.dialogOffset = 50
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            endGame()
        }
    }
    
    func reset() -> Void {
        withAnimation {
            self.overlayOpacity = 0
            self.dialogOpacity = 0
            self.dialogOffset = 50
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            resetBoard()
        }
    }
}
