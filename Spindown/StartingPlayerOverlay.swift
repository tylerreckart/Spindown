//
//  StartingPlayerOverlay.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/1/23.
//

import SwiftUI

struct StartingPlayerOverlay: View {
    @Binding var activePlayer: Participant?
    
    var startGame: () -> ()
    var chooseStartingPlayer: () -> ()
    
    @State private var overlayOpacity: CGFloat = 0
    @State private var contentOffset: CGFloat = 50
    @State private var contentOpacity: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color.black.opacity(overlayOpacity)
            
            VStack {
                Image(systemName: "person.crop.circle")
                    .font(.system(size: 64))
                Text("\(activePlayer?.name ?? "")")
                    .font(.system(size: 64, weight: .black))
                    .padding(.bottom, 5)
                Text("Has been randomly chosen to go first.")
                    .padding(.bottom)
                
                VStack {
                    Button(action: {
                        startGame()
                    }) {
                        Text("Start Game")
                            .font(.system(size: 16, weight: .black))
                            .foregroundColor(Color(.white))
                            .frame(maxWidth: 250)
                            .padding()
                            .background(Color(.systemBlue))
                            .cornerRadius(12)
                    }
                    .padding(.bottom, 5)

                    Button(action: {
                        chooseStartingPlayer()
                    }) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Choose Another Player")
                        }
                        .font(.system(size: 16, weight: .black))
                        .foregroundColor(Color(.white))
                        .frame(maxWidth: 250)
                        .padding()
                        .background(Color(.systemFill))
                        .cornerRadius(12)
                    }
                }
            }
            .opacity(contentOpacity)
            .offset(y: contentOffset)
        }
        .onAppear {
            withAnimation {
                self.overlayOpacity = 0.75
                self.contentOpacity = 1
                self.contentOffset = 0
            }
        }
    }
}
