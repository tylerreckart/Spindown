//
//  PlayerTile.swift
//  Spindown
//
//  Created by Tyler Reckart on 1/29/23.
//

import SwiftUI

enum ControlLayout {
    case bumper
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct ForestTheme {
    var name = "forest"
    var shadow = false
    
    var background: some View {
        Image("Mountain")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
    }
}

struct LifeTotalControls: View {
    @ObservedObject var player: Participant
    var showLifeTotalCalculator: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            Button(action: { player.incrementLifeTotal() }) {
                Image(systemName: "plus")
                    .foregroundColor(.white.opacity(0.5))
                    .font(.system(size: 32, weight: .regular, design: .rounded))
                    .shadow(color: .black.opacity(0.2), radius: 2)
            }
            Spacer()
            Button(action: { showLifeTotalCalculator() }) {
                Text("\(player.lifeTotal)")
                    .font(.system(size: 100, weight: .light, design: .rounded))
                    .shadow(color: .black.opacity(0.2), radius: 4)
                    .transition(.scale(scale: 0.4))
            }
            Spacer()
            Button(action: { player.decrementLifeTotal() }) {
                Image(systemName: "minus")
                    .foregroundColor(.white.opacity(0.5))
                    .font(.system(size: 32, weight: .regular, design: .rounded))
                    .shadow(color: .black.opacity(0.2), radius: 2)
            }
            Spacer()
        }
        .foregroundColor(.white)
    }
}

struct CommanderDamageControls: View {
    @ObservedObject var player: Participant

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.thinMaterial)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            VStack(spacing: 0) {
                Text("Commander Damage")
                    .font(.system(size: 16, weight: .black))
                    .shadow(color: .black.opacity(0.1), radius: 1)

                HStack {
                    Spacer()
                    Button(action: { player.incrementLifeTotal() }) {
                        Image(systemName: "plus")
                            .foregroundColor(.white.opacity(0.5))
                            .font(.system(size: 32, weight: .regular, design: .rounded))
                            .shadow(color: .black.opacity(0.2), radius: 2)
                    }
                    Spacer()
                    Text("\(player.lifeTotal)")
                        .foregroundColor(.white)
                        .font(.system(size: 100, weight: .light, design: .rounded))
                        .shadow(color: .black.opacity(0.2), radius: 4)
                        .transition(.scale(scale: 0.4))
                        .padding(.vertical)
                    Spacer()
                    Button(action: { player.decrementLifeTotal() }) {
                        Image(systemName: "minus")
                            .foregroundColor(.white.opacity(0.5))
                            .font(.system(size: 32, weight: .regular, design: .rounded))
                            .shadow(color: .black.opacity(0.2), radius: 2)
                    }
                    Spacer()
                }
                UIButton(text: "Return To Game", symbol: "arrow.counterclockwise", color: UIColor(named: "PrimaryRed")!, action: {})
                    .frame(maxWidth: 240)
            }
        }
    }
}

enum PlayerTileView {
    case lifeTotal
    case commanderDamage
    case settings
}

struct PlayerTile: View {
    @ObservedObject var player: Participant

    var updateLifeTotal: (Participant, Int) -> Void
    var orientation: TileOrientation = .portrait
    var showLifeTotalCalculator: () -> ()

    @Binding var selectedPlayer: Participant?
    
    @State private var activeSum: Counter = .lifeTotal
    @State private var selectedControlLayout: ControlLayout = .bumper
    
    @State private var theme: Theme?
    
    @State private var currentView: PlayerTileView = .lifeTotal

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                LifeTotalControls(player: player, showLifeTotalCalculator: showLifeTotalCalculator)
                Spacer()
            }
            
//            CommanderDamageControls(player: player)
        }
        .background(theme?.tileBackground)
        .rotationEffect(
            self.orientation == .landscapeReverse
            ? Angle(degrees: 90)
            : self.orientation == .landscape
                ? Angle(degrees: -90)
                : Angle(degrees: 0)
        )
        .onAppear {
            self.theme = player.theme
        }
    }
}
