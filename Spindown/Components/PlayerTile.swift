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

struct PlayerTile: View {
    @ObservedObject var player: Participant
    var color: UIColor
    var updateLifeTotal: (Participant, Int) -> Void
    var orientation: TileOrientation = .portrait
    var showLifeTotalCalculator: () -> ()
    @Binding var selectedPlayer: Participant?
    
    var body: some View {
        ZStack {
            if (self.orientation == .portrait) {
                VStack(spacing: 0) {
                    Button(action: { incrementLifeTotal() }) {
                        Rectangle().fill(Color(color))
                    }
                    
                    Button(action: { decrementLifeTotal() }) {
                        Rectangle().fill(Color(color))
                    }
                }
            } else if (self.orientation == .landscape) {
                HStack(spacing: 0) {
                    Button(action: { incrementLifeTotal() }) {
                        Rectangle().fill(Color(color))
                    }
                    
                    Button(action: { decrementLifeTotal() }) {
                        Rectangle().fill(Color(color))
                    }
                }
            } else if (self.orientation == .landscapeReverse) {
                HStack(spacing: 0) {
                    Button(action: { decrementLifeTotal() }) {
                        Rectangle().fill(Color(color))
                    }
                    
                    Button(action: { incrementLifeTotal() }) {
                        Rectangle().fill(Color(color))
                    }
                }
            }

            VStack {
                    VStack {
                        Text(player.name)
                            .font(.system(size: 20, weight: .regular))
                        Button(action: {
                            showLifeTotalCalculator()
                            selectedPlayer = player
                        }) {
                            Text("\(player.currentLifeTotal)")
                                .font(.system(size: 64, weight: .black))
                        }
                        Image(systemName: "heart.fill")
                            .font(.system(size: 24))
                    }
                    .rotationEffect(
                        self.orientation == .landscapeReverse
                            ? Angle(degrees: 90)
                            : self.orientation == .landscape
                                ? Angle(degrees: -90)
                                : Angle(degrees: 0)
                    )
            }
            .foregroundColor(.white)
        }
        .cornerRadius(16)
    }
    
    func incrementLifeTotal() -> Void {
        player.incrementLifeTotal()
    }
    
    func decrementLifeTotal() -> Void {
        player.decrementLifeTotal()
    }
}
