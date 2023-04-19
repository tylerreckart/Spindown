//
//  CounterOptionsStack.swift
//  Spindown
//
//  Created by Tyler Reckart on 4/19/23.
//

import SwiftUI

struct CounterOptionsStack: View {
    @ObservedObject var player: Participant
    
    @Binding var activeCounter: Counter?

    var body: some View {
        ZStack {
            HStack(spacing: 20) {
                ContentDivider()

                CounterTile(
                    target: .tax,
                    value: player.tax,
                    add: { player.addCounter(.tax) },
                    remove: { player.removeCounter(.tax) },
                    badge: "TaxBadge",
                    activeCounter: $activeCounter
                )
                
                CounterTile(
                    target: .poison,
                    value: player.poison,
                    add: { player.addCounter(.poison) },
                    remove: { player.removeCounter(.poison) },
                    badge: "PoisonCounterBadge",
                    activeCounter: $activeCounter
                )
                
                CounterTile(
                    target: .energy,
                    value: player.energy,
                    add: { player.addCounter(.energy) },
                    remove: { player.removeCounter(.energy) },
                    badge: "EnergyCounterBadge",
                    activeCounter: $activeCounter
                )
                
                CounterTile(
                    target: .experience,
                    value: player.experience,
                    add: { player.addCounter(.experience) },
                    remove: { player.removeCounter(.experience) },
                    badge: "XPCounterBadge",
                    activeCounter: $activeCounter
                )
                
                ContentDivider()
                
                Button(action: {
                    withAnimation {
                        player.toggleMonarchy()
                    }
                }) {
                    VStack(spacing: 15) {
                        Spacer()
                        
                        VStack {
                            if(!player.monarch) {
                                Image("CrownBadge")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60)
                                    .rotationEffect(Angle(degrees: 10))
                            } else {
                                Image("CrownBadgeBroken")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60)
                            }
                        }
                        
                        Text("\(!player.monarch ? "Take" : "Yield") The Crown")
                            .font(.system(size: 10, weight: .black, design: .rounded))
                            .textCase(.uppercase)
                            .foregroundColor(.white)
                            .frame(width: 110)
                        Spacer()
                    }
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 1, y: 1)
                }
                .frame(width: 110, height: 110)
                
                ContentDivider()
                
                HStack(spacing: 20) {
                    CounterTile(
                        target: .tax,
                        value: player.tax,
                        add: { player.addCounter(.tax) },
                        remove: { player.removeCounter(.tax) },
                        badge: "TaxBadge",
                        activeCounter: $activeCounter
                    )
                    
                    CounterTile(
                        target: .poison,
                        value: player.poison,
                        add: { player.addCounter(.poison) },
                        remove: { player.removeCounter(.poison) },
                        badge: "PoisonCounterBadge",
                        activeCounter: $activeCounter
                    )
                    
                    CounterTile(
                        target: .energy,
                        value: player.energy,
                        add: { player.addCounter(.energy) },
                        remove: { player.removeCounter(.energy) },
                        badge: "EnergyCounterBadge",
                        activeCounter: $activeCounter
                    )
                    
                    CounterTile(
                        target: .experience,
                        value: player.experience,
                        add: { player.addCounter(.experience) },
                        remove: { player.removeCounter(.experience) },
                        badge: "XPCounterBadge",
                        activeCounter: $activeCounter
                    )
                }
                .padding(.trailing)
            }
            .padding(.horizontal)
            Spacer()
        }
    }
}

