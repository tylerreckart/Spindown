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

struct OverlayDragGestureHandler: View {
    var orientation: TileOrientation

    @Binding var height: CGFloat
    @Binding var isFullHeight: Bool
    @Binding var dragCompletionPercentage: CGFloat
    @Binding var showOverlay: Bool
    
    @State private var gest: DragGesture = DragGesture(minimumDistance: 20, coordinateSpace: .local)
    
    @State private var greatestFiniteWidth: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .contentShape(Rectangle())
                .gesture(
                    self.gest
                        .onChanged({ gesture in
                            if (isFullHeight) {
                                self.isFullHeight = false
                            }
                            
                            if (!showOverlay) {
                                self.showOverlay = true
                            }
                            
                            let size = geometry.size
                            
                            print("CHANGE: size=\(size)")
                            print("CHANGE: pos=\(gesture.location.x)")
                            
                            if (size.width > greatestFiniteWidth) {
                                greatestFiniteWidth = size.width
                            }
                            
                            print("greatestFiniteWidth=\(greatestFiniteWidth)")
                            
                            withAnimation {
                                if (gesture.location.x > 0) {
                                    if (self.orientation == .landscape) {
                                        let delta = greatestFiniteWidth - gesture.location.x
                                        self.dragCompletionPercentage = delta / greatestFiniteWidth
                                        self.height = delta
                                    } else {
                                        let delta = gesture.location.x
                                        self.dragCompletionPercentage = delta / greatestFiniteWidth
                                        self.height = delta
                                    }
                                }
                            }
                        })
                        .onEnded({ endGesture in
                            let size = geometry.size
                            
                            withAnimation(.spring()) {
                                let pos = endGesture.location.x
                                
                                if (orientation == .landscape) {
                                    if (pos <= greatestFiniteWidth / 2) {
                                        self.height = greatestFiniteWidth
                                        self.isFullHeight = true
                                    } else {
                                        self.height = 0.01
                                        self.isFullHeight = false
                                        self.dragCompletionPercentage = 0
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            self.height = 0
                                            self.showOverlay = false
                                        }
                                    }
                                } else {
                                    let diff = greatestFiniteWidth - pos
                                    print("greatestFiniteWidth=\(greatestFiniteWidth)")
                                    
                                    print("END: pos=\(pos)")
                                    print("END: diff=\(diff)")
                                    
                                    if (diff <= greatestFiniteWidth / 2) {
                                        print("END: should assume full height")
                                        self.height = greatestFiniteWidth
                                        self.isFullHeight = true
                                    } else {
                                        print("END: should reset")
                                        self.height = 0.01
                                        self.isFullHeight = false
                                        self.dragCompletionPercentage = 0
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            self.height = 0
                                            self.showOverlay = false
                                        }
                                    }
                                }
                            }
                        })
                )
        }
    }
}

struct VerticalLifeTotalControls: View {
    @ObservedObject var player: Participant
    
    var orientation: TileOrientation
    var showLifeTotalCalculator: () -> Void
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    @State private var showInteractionHandle: Bool = false
    @State private var showOverlay: Bool = false
    @State private var overlayViewHeight: CGFloat = 0
    @State private var overlayDragCompletionPercentage: CGFloat = 0
    @State private var overlayIsFullHeight: Bool = false
    
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
            
            ZStack {
                Circle().fill(.clear).frame(width: 24)
                Image(systemName: "ellipsis")
                    .rotationEffect(Angle(degrees: orientation == .landscape ? 90 : -90))
                    .font(.system(size: 24, weight: .regular))
                    .foregroundColor(.white.opacity(0.5))
                    .shadow(color: .black.opacity(0.2), radius: 2)
            }
            
            if (orientation != .landscape) {
                Spacer()
            }
        }
    }
    
    @State private var gest: DragGesture = DragGesture(minimumDistance: 20, coordinateSpace: .local)

    var body: some View {
        ZStack {
            OverlayDragGestureHandler(
                orientation: orientation,
                height: $overlayViewHeight,
                isFullHeight: $overlayIsFullHeight,
                dragCompletionPercentage: $overlayDragCompletionPercentage,
                showOverlay: $showOverlay
            )

            VStack(spacing: 20) {
                Spacer()
                if (orientation == .landscape) {
                    plusButton
                } else {
                    minusButton
                }
                Spacer()
                    .frame(maxHeight: 10)
                total
                Spacer()
                    .frame(maxHeight: 10)
                if (orientation == .landscape) {
                    minusButton
                } else {
                    plusButton
                }
                Spacer()
            }
            .opacity(1 - overlayDragCompletionPercentage)
            .scaleEffect(1 - (overlayDragCompletionPercentage / 5))
            
            
            if (showInteractionHandle) {
                interactionHandle
            }
            
            if (overlayViewHeight > 0 && showOverlay) {
                HStack {
                    if (orientation == .landscape && !overlayIsFullHeight) {
                        Spacer()
                    }
                    
                    ZStack {
                        Rectangle().fill(.ultraThinMaterial)
                            .edgesIgnoringSafeArea(.all)
                            .shadow(color: .black.opacity(0.1), radius: 3)
                        
                        OverlayDragGestureHandler(
                            orientation: orientation,
                            height: $overlayViewHeight,
                            isFullHeight: $overlayIsFullHeight,
                            dragCompletionPercentage: $overlayDragCompletionPercentage,
                            showOverlay: $showOverlay
                        )
                        
                        if (overlayIsFullHeight) {
                            ZStack {
                                HStack {
                                    if (orientation != .landscape) {
                                        Spacer()
                                        Image(systemName: "chevron.compact.left")
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(.white.opacity(0.2))
                                            .padding(10)
                                            .shadow(color: .black.opacity(0.1), radius: 2)
                                            .transition(.push(from: .leading))
                                    }
                                    
                                    if (orientation == .landscape) {
                                        Image(systemName: "chevron.compact.right")
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(.white.opacity(0.2))
                                            .padding(10)
                                            .shadow(color: .black.opacity(0.1), radius: 2)
                                            .transition(.push(from: .leading))
                                        Spacer()
                                    }
                                }
                                
                                HStack {
                                    VStack(spacing: 20) {
                                        VStack {
                                            Spacer()
                                            Image(systemName: "figure.run.circle.fill")
                                                .font(.system(size: 32))
                                            Spacer()
                                            Text("Commander")
                                                .font(.system(size: 7.4, weight: .black))
                                            Text("Damage")
                                                .font(.system(size: 12, weight: .black))
                                            Spacer()
                                        }
                                        .padding(12)
                                        .frame(width: 80, height: 90)
                                        .textCase(.uppercase)
                                        .background(.clear)
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(LinearGradient(colors: [.white.opacity(0.3), .white.opacity(0.2)], startPoint: .top, endPoint: .bottom), lineWidth: 4)
                                                .shadow(radius: 3)
                                        )
                                        .rotationEffect(Angle(degrees: orientation == .landscape ? 90 : -90))
                                        
                                        VStack {
                                            Spacer()
                                            Image(systemName: "paintpalette.fill")
                                                .font(.system(size: 32))
                                            Spacer()
                                            Text("Customize")
                                                .font(.system(size: 7.4, weight: .black))
                                            Text("Player")
                                                .font(.system(size: 12, weight: .black))
                                            Spacer()
                                        }
                                        .padding(12)
                                        .frame(width: 80, height: 90)
                                        .textCase(.uppercase)
                                        .background(.clear)
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(LinearGradient(colors: [.white.opacity(0.3), .white.opacity(0.2)], startPoint: .top, endPoint: .bottom), lineWidth: 4)
                                                .shadow(radius: 3)
                                        )
                                        .rotationEffect(Angle(degrees: orientation == .landscape ? 90 : -90))
                                    }
                                }
                            }
                        }
                    }
                    .frame(maxWidth: overlayViewHeight, maxHeight: .infinity)
                    
                    if (orientation != .landscape && !overlayIsFullHeight) {
                        Spacer()
                    }
                }
            }
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
        .onChange(of: overlayIsFullHeight) { newState in
            print(newState)
        }
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
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image(player.theme?.backgroundKey ?? "")
                .resizable()
                .aspectRatio(contentMode: .fill)
        )
        .clipped()
        .cornerRadius(8)
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
        HorizontalLifeTotalControls(
            player: player,
            showLifeTotalCalculator: showLifeTotalCalculator
        )
    }
}
