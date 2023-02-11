//
//  PlayerTile.swift
//  Spindown
//
//  Created by Tyler Reckart on 1/29/23.
//

import SwiftUI

enum TileOrientation {
    case landscape
    case landscapeReverse
    case portrait
}

enum ActiveSum {
    case lifeTotal
    case poison
    case energy
    case experience
    case tickets
}

struct PlayerTileControls: View {
    @ObservedObject var player: Participant
    @Binding var activeSum: ActiveSum
    var orientation: TileOrientation
    var color: UIColor

    var body: some View {
        if (self.orientation == .portrait) {
            VStack(spacing: 0) {
                Button(action: { increment() }) {
                    Rectangle().fill(Color(color))
                }
                
                Button(action: { decrement() }) {
                    Rectangle().fill(Color(color))
                }
            }
        } else if (self.orientation == .landscape) {
            HStack(spacing: 0) {
                Button(action: { increment() }) {
                    Rectangle().fill(Color(color))
                }
                
                Button(action: { decrement() }) {
                    Rectangle().fill(Color(color))
                }
            }
        } else if (self.orientation == .landscapeReverse) {
            HStack(spacing: 0) {
                Button(action: { decrement() }) {
                    Rectangle().fill(Color(color))
                }
                
                Button(action: { increment() }) {
                    Rectangle().fill(Color(color))
                }
            }
        }
    }
    
    func increment() -> Void {
        if (self.activeSum == .lifeTotal) {
            player.incrementLifeTotal()
        } else if (self.activeSum == .poison) {
            player.addCounter(.poison)
        } else if (self.activeSum == .energy) {
            player.addCounter(.energy)
        } else if (self.activeSum == .experience) {
            player.addCounter(.experience)
        } else if (self.activeSum == .tickets) {
            player.addCounter(.tickets)
        }
    }
    
    func decrement() -> Void {
        if (self.activeSum == .lifeTotal) {
            player.decrementLifeTotal()
        } else if (self.activeSum == .poison) {
            player.removeCounter(.poison)
        } else if (self.activeSum == .energy) {
            player.removeCounter(.energy)
        } else if (self.activeSum == .experience) {
            player.removeCounter(.experience)
        } else if (self.activeSum == .tickets) {
            player.removeCounter(.tickets)
        }
    }
}

struct PlayerTile: View {
    @ObservedObject var player: Participant
    var color: UIColor
    var updateLifeTotal: (Participant, Int) -> Void
    var orientation: TileOrientation = .portrait
    var showLifeTotalCalculator: () -> ()
    @Binding var selectedPlayer: Participant?
    
    @State private var activeSum: ActiveSum = .lifeTotal
    
    var body: some View {
        ZStack {
            PlayerTileControls(player: player, activeSum: $activeSum, orientation: orientation, color: color)

            VStack(spacing: 0) {
                Spacer()
                VStack(spacing: 0) {
                        if (self.activeSum == .lifeTotal) {
                            HStack(spacing: 0) {
                                Spacer()
                                VStack(spacing: 0) {
                                    Text(player.name)
                                        .font(.system(size: 20, weight: .regular))
                                    Button(action: {
                                        selectedPlayer = player

                                        withAnimation(.easeInOut) {
                                            showLifeTotalCalculator()
                                        }
                                    }) {
                                        Text("\(player.lifeTotal)")
                                            .font(.system(size: 64, weight: .black))
                                    }
                                    Button(action: {
                                        withAnimation(.linear(duration: 0.2)) {
                                            self.activeSum = .poison
                                        }
                                    }) {
                                        Image(systemName: "heart.fill")
                                            .font(.system(size: 24))
                                    }
                                }
                                .transition(
                                    .asymmetric(
                                        insertion: .scale.combined(with: .opacity),
                                        removal: .scale.combined(with: .opacity)
                                    )
                                )
                                Spacer()
                            }
                        } else if (self.activeSum == .poison) {
                            HStack(spacing: 0) {
                                Spacer()
                                VStack(spacing: 0) {
                                    Text("Poison")
                                        .font(.system(size: 20, weight: .regular))
                                    Text("\(player.poison)")
                                        .font(.system(size: 64, weight: .black))
                                    Button(action: {
                                        withAnimation(.linear(duration: 0.2)) {
                                            self.activeSum = .energy
                                        }
                                    }) {
                                        Image(systemName: "drop.triangle.fill")
                                            .font(.system(size: 24, weight: .black))
                                    }
                                }
                                .transition(
                                    .asymmetric(
                                        insertion: .scale.combined(with: .opacity),
                                        removal: .scale.combined(with: .opacity)
                                    )
                                )
                                Spacer()
                            }
                        } else if (self.activeSum == .energy) {
                            HStack(spacing: 0) {
                                Spacer()
                                VStack(spacing: 0) {
                                    Text("Energy")
                                        .font(.system(size: 20, weight: .regular))
                                    Text("\(player.energy)")
                                        .font(.system(size: 64, weight: .black))
                                    Button(action: {
                                        withAnimation {
                                            self.activeSum = .experience
                                        }
                                    }) {
                                        Image(systemName: "bolt.fill")
                                            .font(.system(size: 24, weight: .black))
                                    }
                                }
                                .transition(
                                    .asymmetric(
                                        insertion: .scale.combined(with: .opacity),
                                        removal: .scale.combined(with: .opacity)
                                    )
                                )
                                Spacer()
                            }
                        } else if (self.activeSum == .experience) {
                            HStack(spacing: 0) {
                                Spacer()
                                VStack(spacing: 0) {
                                    Text("Experience")
                                        .font(.system(size: 20, weight: .regular))
                                    Text("\(player.experience)")
                                        .font(.system(size: 64, weight: .black))
                                    Button(action: {
                                        withAnimation {
                                            self.activeSum = .tickets
                                        }
                                    }) {
                                        Image(systemName: "magazine.fill")
                                            .font(.system(size: 24, weight: .bold))
                                    }
                                }
                                .transition(
                                    .asymmetric(
                                        insertion: .scale.combined(with: .opacity),
                                        removal: .scale.combined(with: .opacity)
                                    )
                                )
                                Spacer()
                            }
                        } else if (self.activeSum == .tickets) {
                            HStack(spacing: 0) {
                                Spacer()
                                VStack(spacing: 0) {
                                    Text("Tickets")
                                        .font(.system(size: 20, weight: .regular))
                                    Text("\(player.tickets)")
                                        .font(.system(size: 64, weight: .black))
                                    Button(action: {
                                        withAnimation {
                                            self.activeSum = .lifeTotal
                                        }
                                    }) {
                                        Image(systemName: "ticket.fill")
                                            .font(.system(size: 24, weight: .bold))
                                    }
                                }
                                .transition(
                                    .asymmetric(
                                        insertion: .scale.combined(with: .opacity),
                                        removal: .scale(scale: 0.8).combined(with: .opacity)
                                    )
                                )
                                Spacer()
                            }
                        }
                    }
                    .rotationEffect(
                        self.orientation == .landscapeReverse
                            ? Angle(degrees: 90)
                            : self.orientation == .landscape
                                ? Angle(degrees: -90)
                                : Angle(degrees: 0)
                    )
                Spacer()
            }
            .foregroundColor(.white)
        }
        .cornerRadius(16)
    }
}
