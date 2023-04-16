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

struct VerticalLifeTotalControls: View {
    @ObservedObject var player: Participant
    
    var orientation: TileOrientation
    var showLifeTotalCalculator: () -> Void
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    @State private var showInteractionHandle: Bool = false
    @State private var isDragging: Bool = false
    
    private func increment() -> Void {
        player.incrementLifeTotal()
        
        if (!showInteractionHandle) {
            withAnimation {
                self.showInteractionHandle = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    self.showInteractionHandle = false
                }
            }
        }
    }

    private func decrement() -> Void {
        player.decrementLifeTotal()
        
        if (!showInteractionHandle) {
            withAnimation {
                self.showInteractionHandle = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    self.showInteractionHandle = false
                }
            }
        }
    }
    
    var plusButton: some View {
        Button(action: increment) {
            Image(systemName: "plus")
                .foregroundColor(.white.opacity(0.5))
                .font(.system(size: 32, weight: .regular, design: .rounded))
                .shadow(color: .black.opacity(0.2), radius: 2)
        }
    }
    
    var minusButton: some View {
        Button(action: decrement) {
            ZStack {
                Circle()
                    .fill(.clear)
                    .frame(maxWidth: 32)
                Image(systemName: "minus")
                    .foregroundColor(.white.opacity(0.5))
                    .font(.system(size: 32, weight: .regular, design: .rounded))
                    .shadow(color: .black.opacity(0.2), radius: 2)
                    .rotationEffect(Angle(degrees: 90))
            }
        }
    }
    
    var total: some View {
        Button(action: { showLifeTotalCalculator() }) {
            Text("\(player.lifeTotal)")
                .rotationEffect(Angle(degrees: orientation == .landscape ? 90 : -90))
                .font(.system(size: 84, weight: .light, design: .rounded))
                .shadow(color: .black.opacity(0.2), radius: 4)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
    }
    
    var interactionHandle: some View {
        HStack {
            if (orientation == .landscape) {
                Spacer()
            }
            
            Image(systemName: "ellipsis")
                .rotationEffect(Angle(degrees: orientation == .landscape ? 90 : -90))
                .font(.system(size: 24, weight: .regular))
                .foregroundColor(.white.opacity(0.5))
                .shadow(color: .black.opacity(0.2), radius: 2)
            
            if (orientation != .landscape) {
                Spacer()
            }
        }
    }

    var drag: some Gesture {
        DragGesture()
            .onChanged { _ in self.isDragging = true }
            .onEnded { _ in self.isDragging = false }
    }

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Spacer()
                if (orientation == .landscape) {
                    plusButton
                } else {
                    minusButton
                }
                Spacer()
                total
                Spacer()
                if (orientation == .landscape) {
                    minusButton
                } else {
                    plusButton
                }
                Spacer()
            }
            
            if (self.showInteractionHandle) {
                interactionHandle
            }
            
//            HStack {
//                if (orientation == .landscape) {
//                    Spacer()
//                }
//
//                Rectangle().fill(.ultraThinMaterial).frame(width: 50)
//                    .gesture(drag)
//
//                if (orientation != .landscape) {
//                    Spacer()
//                }
//            }
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image(player.theme?.backgroundKey ?? "")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .rotationEffect(Angle(degrees: orientation == .landscape ? 90 : -90))
                .padding(orientation == .landscape ? .trailing : .leading, 80)
        )
        .clipped()
        .cornerRadius(8)
    }
}

struct HorizontalLifeTotalControls: View {
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
        .frame(maxHeight: .infinity)
        .foregroundColor(.white)
        .background(
            Image(player.theme?.backgroundKey ?? "")
                .resizable()
                .aspectRatio(contentMode: .fill)
        )
        .clipped()
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
        if (orientation == .portrait) {
            HorizontalLifeTotalControls(
                player: player,
                showLifeTotalCalculator: showLifeTotalCalculator
            )
        } else {
            VerticalLifeTotalControls(
                player: player,
                orientation: orientation,
                showLifeTotalCalculator: showLifeTotalCalculator
            )
        }
    }
}
