//
//  CommanderDamageCounterOverlay.swift
//  Spindown
//
//  Created by Tyler Reckart on 4/20/23.
//

import SwiftUI

struct CommanderDamageCounterOverlay: View {
    @ObservedObject var player: Participant
    
    var target: Participant
    
    @State private var index: Int?

    var body: some View {
        ZStack {
            VStack {
                Text("Damage Dealt")
                    .font(.system(size: 10, weight: .black, design: .rounded))
                    .textCase(.uppercase)
                    .foregroundColor(.white)
                    .padding(20)
                Spacer()
            }
            .frame(maxHeight: 300)
            
            ZStack {
                if (index != nil) {
                    Text("\(player.cmdrDamageDealt[index!].total)")
                        .font(.system(size: 100, weight: .light, design: .rounded))
                        .shadow(color: .black.opacity(0.2), radius: 4)
                        .transition(.scale(scale: 0.4))
                } else {
                    Text("0")
                        .font(.system(size: 100, weight: .light, design: .rounded))
                        .shadow(color: .black.opacity(0.2), radius: 4)
                        .transition(.scale(scale: 0.4))
                }
                
                HStack {
                    Button(action: incrementDamage) {
                        ZStack {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 50)
//                                .opacity(0)
                            
                            Image(systemName: "plus")
                                .foregroundColor(.white.opacity(0.5))
                                .font(.system(size: 32, weight: .regular, design: .rounded))
                                .shadow(color: .black.opacity(0.2), radius: 2)
                        }
                    }
                    Spacer()
                    Button(action: decrementDamage) {
                        ZStack {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 50)
//                                .opacity(0)
                            
                            Image(systemName: "minus")
                                .foregroundColor(.white.opacity(0.5))
                                .font(.system(size: 32, weight: .regular, design: .rounded))
                                .shadow(color: .black.opacity(0.2), radius: 2)
                        }
                    }
                }
                .frame(maxWidth: 220)
            }
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .overlay(LinearGradient(
                    colors: [.black.opacity(0.8), .black.opacity(0.2)],
                    startPoint: .top,
                    endPoint: .bottom
                ))
        )
        .onAppear {
            self.index = player.cmdrDamageDealt.firstIndex(where: { target.id == $0.player.id })
        }
    }
    
    func incrementDamage() -> Void {
        if (index != nil) {
            player.cmdrDamageDealt[index!].total = player.cmdrDamageDealt[index!].total + 1
            target.incrementCmdrDamage()
        } else {
            self.index = 0
            var entry = CommanderDamageDealt(player: target, total: 1)
            player.cmdrDamageDealt.append(entry)
            target.incrementCmdrDamage()
        }
    }
    
    func decrementDamage() -> Void {
        if (index != nil) {
            let nextTotal = player.cmdrDamageDealt[index!].total - 1
            
            if (nextTotal >= 0) {
                player.cmdrDamageDealt[index!].total = player.cmdrDamageDealt[index!].total - 1
            }

            target.decrementCmdrDamage()
        } else {
            self.index = 0
            var entry = CommanderDamageDealt(player: target, total: 0)
            player.cmdrDamageDealt.append(entry)
        }
    }
}
