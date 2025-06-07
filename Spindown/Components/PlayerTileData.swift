//
//  PlayerTileData.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/27/23.
//

import SwiftUI

struct PlayerTileData: View {
    @Binding var activeSum: Counter

    var value: Int
    var label: String
    var symbol: String
    var useCustomSymbol: Bool = false
    var nextTile: Counter
    var showLifeTotalCalculator: () -> Void
    
    public var fontSize: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 64
        } else {
            return 48
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            VStack(spacing: 0) {
                Text(label)
                    .font(.system(size: 20, weight: .regular))
                Button(action: {
                    showLifeTotalCalculator()
                }) {
                    Text("\(value)")
                        .font(.system(size: fontSize, weight: .black))
                    
                }
                Button(action: {
                    HapticsManager.shared.selectionChanged()
                    withAnimation(.linear(duration: 0.2)) {
                        self.activeSum = nextTile
                    }
                }) {
                    ZStack {
                        Circle().fill(.clear).frame(width: 40, height: 40)

                        if (self.useCustomSymbol) {
                            Image(symbol)
                                .resizable()
                                .frame(width: 18.67, height: 28)
                        } else {
                            Image(systemName: symbol)
                                .font(.system(size: 24, weight: .black))
                        }
                    }
                }
                .padding(.top, -5)
            }
            .transition(
                .asymmetric(
                    insertion: .scale.combined(with: .opacity),
                    removal: .scale.combined(with: .opacity)
                )
            )
            Spacer()
        }
    }
}
