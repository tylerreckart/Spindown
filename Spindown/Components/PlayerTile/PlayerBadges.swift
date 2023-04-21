//
//  PlayerBadges.swift
//  Spindown
//
//  Created by Tyler Reckart on 4/18/23.
//

import SwiftUI

struct CounterBadge: View {
    var counter: Counter

    @Binding var showOverlay: Bool
    @Binding var activeCounter: Counter?

    var body: some View {
        Button(action: {
            self.showOverlay.toggle()
            self.activeCounter = counter
        }) {
            Image("\(counter.rawValue.prefix(1).uppercased() + counter.rawValue.lowercased().dropFirst())Badge")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30)
                .shadow(radius: 2, x: 1, y: 1)
        }
    }
}

struct PlayerBadges: View {
    @ObservedObject var player: Participant

    @Binding var showOverlay: Bool
    @Binding var selectedCounter: Counter?
    @Binding var orientation: UIDeviceOrientation?

    var body: some View {
        VStack {
            HStack(spacing: 0) {
                if (orientation == .landscapeLeft) {
                    Rectangle().fill(.clear)
                        .frame(maxWidth: 34, maxHeight: 0)
                }
                
                HStack {
                    ForEach(Array(player.activeCounters), id: \.self) { counter in
                        CounterBadge(counter: counter, showOverlay: $showOverlay, activeCounter: $selectedCounter)
                            .transition(.opacity)
                    }
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
                
                if (orientation == .landscapeRight) {
                    Rectangle().fill(.clear)
                        .frame(maxWidth: 34, maxHeight: 0)
                }
            }
            .padding()
            
            Spacer()
        }
    }
}

