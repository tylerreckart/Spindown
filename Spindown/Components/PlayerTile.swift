//
//  PlayerTile.swift
//  Spindown
//
//  Created by Tyler Reckart on 1/29/23.
//

import SwiftUI

struct PlayerTile: View {
    @ObservedObject var player: Participant

    var updateLifeTotal: (Participant, Int) -> Void
    var orientation: TileOrientation = .portrait
    var showLifeTotalCalculator: () -> ()

    @Binding var selectedPlayer: Participant?
    
    @State private var activeSum: Counter = .lifeTotal
    
    public var fontSize: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 64
        } else {
            return 48
        }
    }
    
    var body: some View {
        ZStack {
            PlayerTileControls(player: player, activeSum: $activeSum, orientation: orientation)

            VStack(spacing: 0) {
                Spacer()
                VStack(spacing: 0) {
                    switch (self.activeSum) {
                        case .lifeTotal:
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
                                            .font(.system(size: fontSize, weight: .black))
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
                        case .poison:
                            PlayerTileData(
                                activeSum: $activeSum,
                                value: player.poison,
                                label: "Poison",
                                symbol: "ToxicSymbol",
                                useCustomSymbol: true,
                                nextTile: .energy
                            )
                        case .energy:
                            PlayerTileData(
                                activeSum: $activeSum,
                                value: player.energy,
                                label: "Energy",
                                symbol: "bolt.fill",
                                nextTile: .experience
                            )
                        case .experience:
                            PlayerTileData(
                                activeSum: $activeSum,
                                value: player.experience,
                                label: "Experience",
                                symbol: "magazine.fill",
                                nextTile: .tickets
                            )
                        case .tickets:
                            PlayerTileData(
                                activeSum: $activeSum,
                                value: player.tickets,
                                label: "Tickets",
                                symbol: "ticket.fill",
                                nextTile: .lifeTotal
                            )
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
