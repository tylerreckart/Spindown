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
    var useBackground = false
    
    var overlay: some View {
        Image("WrathfulDragon")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
    }
}

struct SpellbookTheme {
    var name = "spellbook"
    var shadow = true
    var useBackground = true

    var background: some View {
        Image("TableTexture")
            .resizable()
            .frame(maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
    }

    var overlay: some View {
        ZStack {
            Color.black
            
            GeometryReader { proxy in
                ZStack {
                    ZStack {
                        Color.init(hex: "846524")
                    
                        Path { path in
                            path.move(to: CGPoint(x: 0, y: 0))
                            path.addLine(to: CGPoint(x: 0, y: proxy.size.height))
                            path.addLine(to: CGPoint(x: proxy.size.width, y: proxy.size.height))
                        }
                        .fill(Color.init(hex: "2b200c"))
                        .clipShape(Rectangle())
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    ZStack {
                        Rectangle()
                            .fill(Color.init(hex: "493611"))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(24)
                            .overlay(
                                Rectangle()
                                    .fill(Color.init(hex: "211809"))
                                    .padding(34)
                                    .overlay(
                                        Rectangle()
                                            .fill(Color.init(hex: "634a19"))
                                            .padding(36)
                                            .overlay(
                                                Rectangle()
                                                    .fill(Color.init(hex: "493611"))
                                                    .padding(38)
                                            )
                                    )
                            )
                        
                        VStack {
                            HStack {
                                Circle()
                                    .fill(.red)
                                    .frame(width: 10)
                                Spacer()
                                Circle()
                                    .fill(.red)
                                    .frame(width: 10)
                            }
                            Spacer()
                            HStack {
                                Circle()
                                    .fill(.red)
                                    .frame(width: 10)
                                Spacer()
                                Circle()
                                    .fill(.red)
                                    .frame(width: 10)
                            }
                        }
                        .padding(48)
                        
                        Ellipse()
                            .fill(Color.init(hex: "211809"))
                            .frame(maxWidth: proxy.size.width - 90, maxHeight: proxy.size.height - 90)
                            .overlay(
                                Ellipse()
                                    .fill(Color.init(hex: "56688e"))
                                    .padding(2)
                                    .overlay(
                                        Ellipse()
                                            .fill(Color.init(hex: "8c562a"))
                                            .padding(6)
                                    )
                            )
                    }
                }
            }
        }
    }
}

struct PlayerTile: View {
    @ObservedObject var player: Participant

    var updateLifeTotal: (Participant, Int) -> Void
    var orientation: TileOrientation = .portrait
    var showLifeTotalCalculator: () -> ()

    @Binding var selectedPlayer: Participant?
    
    @State private var activeSum: Counter = .lifeTotal
    @State private var selectedControlLayout: ControlLayout = .bumper
    
    @State private var theme = ForestTheme()
    
    public var fontSize: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 64
        } else {
            return 48
        }
    }
    
    var body: some View {
        ZStack {
            if (self.selectedControlLayout == .bumper) {
                PlayerTileControls(player: player, activeSum: $activeSum, orientation: orientation)
            }

            VStack(spacing: 0) {
                PlayerTileData(
                    activeSum: $activeSum,
                    value: player.lifeTotal,
                    label: player.name,
                    symbol: "heart.fill",
                    nextTile: .poison
                )
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
        .background(theme.overlay)
    }
}
