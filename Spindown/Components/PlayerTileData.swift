//
//  PlayerTileData.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/27/23.
//

import SwiftUI

struct PlayerTileHorizontal {
    @Binding var activeSum: Counter
    
    public var fontSize: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 64
        } else {
            return 48
        }
    }
}

struct PlayerTileData: View {
    @Binding var activeSum: Counter

    var value: Int
    var label: String
    var symbol: String
    var useCustomSymbol: Bool = false
    var nextTile: Counter
    
    @State private var showPlayerName: Bool = false

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                Text(label)
                    .font(.system(size: 16, design: .rounded))
                    .shadow(color: .black.opacity(0.1), radius: 1)
                Spacer()
                HStack(spacing: 0) {
                    Spacer()
                    Image(systemName: "plus")
                        .foregroundColor(.white.opacity(0.5))
                        .font(.system(size: 32, weight: .regular, design: .rounded))
                        .shadow(color: .black.opacity(0.2), radius: 2)
                    Spacer()
                    Text("\(value)")
                        .font(.system(size: 100, weight: .light, design: .rounded))
                        .shadow(color: .black.opacity(0.2), radius: 4)
                    Spacer()
                    Image(systemName: "minus")
                        .foregroundColor(.white.opacity(0.5))
                        .font(.system(size: 32, weight: .regular, design: .rounded))
                        .shadow(color: .black.opacity(0.2), radius: 2)
                    Spacer()
                }
                Spacer()
                VStack {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 18))
                        .shadow(color: .black.opacity(0.2), radius: 4)
                }
                Spacer()
            }
        }
    }
}
