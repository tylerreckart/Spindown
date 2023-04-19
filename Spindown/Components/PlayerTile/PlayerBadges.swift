//
//  PlayerBadges.swift
//  Spindown
//
//  Created by Tyler Reckart on 4/18/23.
//

import SwiftUI

struct PlayerBadges: View {
    @ObservedObject var player: Participant

    @Binding var showOverlay: Bool
    @Binding var selectedCounter: Counter?

    var body: some View {
        VStack {
            HStack {
                HStack {
                    ZStack {
                        Button(action: {
                            self.showOverlay.toggle()
                            self.selectedCounter = .experience
                        }) {
                            Image("XPCounterBadge")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30)
                                .shadow(radius: 2, x: 1, y: 1)
                        }
                        
                        Button(action: {
                            self.showOverlay.toggle()
                            self.selectedCounter = .poison
                        }) {
                            Image("PoisonCounterBadge")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30)
                                .shadow(radius: 2, x: 1, y: 1)
                        }
                        .offset(x: 38, y: 8)
                        
                        Button(action: {
                            self.showOverlay.toggle()
                            self.selectedCounter = .energy
                        }) {
                            Image("EnergyCounterBadge")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30)
                                .shadow(radius: 2, x: 1, y: 1)
                        }
                        .offset(x: 8, y: 38)
                    }
                    
                    Spacer()
                    
                    if (player.monarch) {
                        Image("CrownBadge")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 30)
                            .rotationEffect(Angle(degrees: 10))
                            .shadow(radius: 3)
                            .transition(.opacity)
                    }
                }
                Spacer()
            }
            .padding()
            Spacer()
        }
    }
}
