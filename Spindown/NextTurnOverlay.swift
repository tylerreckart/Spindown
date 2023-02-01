//
//  NextTurnOverlay.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/1/23.
//

import SwiftUI

struct NextTurnOverlay: View {
    @Binding var activePlayer: Participant?
    
    @State private var playerTextOffset: CGFloat = -60
    @State private var playerTextOpacity: CGFloat = 0
    @State private var overlayOpacity: CGFloat = 0

    var body: some View {
        ZStack {
            Color.black.opacity(overlayOpacity)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center) {
                Spacer()

                Text("\(activePlayer?.name ?? "")'s Turn")
                    .font(.system(size: 72, weight: .black))
                    .italic()
                    .foregroundColor(Color(.white))
                    .offset(x: playerTextOffset)
                    .opacity(playerTextOpacity)

                Spacer()
            }
        }
        .onAppear {
            withAnimation {
                print("NextTurnOverlay appear")
                self.playerTextOffset = 0
                self.playerTextOpacity = 1
                self.overlayOpacity = 0.75
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    print("NextTurnOverlay async dismiss")
                    self.playerTextOffset = 60
                    self.playerTextOpacity = 0
                    self.overlayOpacity = 0
                }
            }
        }
    }
}
