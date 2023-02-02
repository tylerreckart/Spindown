//
//  GameSettingsDialog.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/2/23.
//

import SwiftUI

struct GameSettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        LayoutSelectorView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


struct DiceRollView: View {
    var body: some View {
        Text("Dice Roll")
    }
}

struct TimerView: View {
    var body: some View {
        Text("Timer")
    }
}

struct TwoPlayerLayoutCard: View {
    var p1Rotation: CGFloat = 0
    var p2Rotation: CGFloat = 0
    var layout: TwoPlayerLayout
    
    @Binding var selectedLayout: TwoPlayerLayout

    var body: some View {
        VStack {
            Button(action: {
                self.selectedLayout = layout
            }) {
                VStack(spacing: 6) {
                    ZStack {
                        Rectangle()
                            .fill(Color(UIColor(named: "AccentGrayDarker") ?? .systemGray))
                            .frame(width: 60, height: 40)
                            .cornerRadius(6)
                            .overlay(LinearGradient(colors: [Color.white.opacity(0.1), .clear], startPoint: .top, endPoint: .bottom))
                        Image(systemName: "person.fill")
                            .foregroundColor(Color(UIColor(named: "AccentGray") ?? .systemGray))
                            .font(.system(size: 20, weight: .black))
                            .rotationEffect(Angle(degrees: p1Rotation))
                            .shadow(color: Color.black.opacity(0.4), radius: 8)
                    }
                    
                    ZStack {
                        Rectangle()
                            .fill(Color(UIColor(named: "AccentGrayDarker") ?? .systemGray))
                            .overlay(LinearGradient(colors: [Color.white.opacity(0.1), .clear], startPoint: .top, endPoint: .bottom))
                            .frame(width: 60, height: 40)
                            .cornerRadius(6)
                        Image(systemName: "person.fill")
                            .foregroundColor(Color(UIColor(named: "AccentGray") ?? .systemGray))
                            .font(.system(size: 20, weight: .black))
                            .rotationEffect(Angle(degrees: p2Rotation))
                            .shadow(color: Color.black.opacity(0.4), radius: 8)
                    }
                }
                .padding(11)
                .background(
                    Color(.systemGray)
                        .overlay(LinearGradient(colors: [Color.white.opacity(0.2), .clear], startPoint: .top, endPoint: .bottom))
                        .overlay(RoundedRectangle(cornerRadius: 8).fill(Color.black).padding(4))
                )
                .cornerRadius(12)
            }
            
            Image(systemName: self.selectedLayout == layout ? "checkmark.circle.fill" : "circle")
                .foregroundColor(self.selectedLayout == layout ? Color.white : Color(UIColor(named: "AccentGrayDarker") ?? .systemGray))
                .font(.system(size: 18, weight: .black))
                .padding(.top, 5)
        }
    }
}

struct LayoutSelectorView: View {
    @State private var selectedLayout: TwoPlayerLayout = .tandem

    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Text("Change Layout")
                    .font(.system(size: 24, weight: .black))
                    .foregroundColor(Color.white)
                Spacer()
            }
            VStack(spacing: 20) {
                HStack(spacing: 0) {
                    TwoPlayerLayoutCard(p1Rotation: 90, p2Rotation: 90, layout: .tandem, selectedLayout: $selectedLayout)
                    Spacer()
                    TwoPlayerLayoutCard(p1Rotation: 90, p2Rotation: -90, layout: .facingLandscape, selectedLayout: $selectedLayout)
                    Spacer()
                    TwoPlayerLayoutCard(p1Rotation: 180, p2Rotation: 0, layout: .facingPortrait, selectedLayout: $selectedLayout)
                }
                
                VStack(spacing: 10) {
                    UIButton(text: "Save", color: UIColor(named: "AccentGrayDarker") ?? .systemBlue, action: {})
                    UIButtonOutlined(text: "Cancel", fill: .black, color: UIColor(named: "AccentGray") ?? .systemGray, action: {})
                }
            }
        }
    }
}

struct FormatSelectorView: View {
    var body: some View {
        Text("Format")
    }
}

struct PlayerSelectorView: View {
    var body: some View {
        Text("Player")
    }
}

struct GameSettingsHomeView: View {
    var endGame: () -> ()
    var dismissModal: () -> ()
    
    @Binding var activeView: ActiveSettingsView

    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Text("Settings")
                    .font(.system(size: 24, weight: .black))
                    .foregroundColor(Color.white)
                Spacer()
            }
            
            VStack(spacing: 15) {
                HStack(spacing: 15) {
                    UIButtonStacked(text: "Timer", symbol: "stopwatch", color: UIColor(named: "AccentGrayDarker") ?? .systemGray, action: {
                        withAnimation {
                            self.activeView = .timer
                        }
                    })
                    UIButtonStacked(text: "Roll Dice", symbol: "dice", color: UIColor(named: "AccentGrayDarker") ?? .systemGray, action: {
                        withAnimation {
                            self.activeView = .roll
                        }
                    })
                    UIButtonStacked(text: "Rules", symbol: "book", color: UIColor(named: "AccentGrayDarker") ?? .systemGray, action: {})
                }
                UIButtonOutlined(text: "Change Layout", symbol: "uiwindow.split.2x1", fill: .black, color: UIColor(named: "AccentGray")!, action: {
                    withAnimation {
                        self.activeView = .layout
                    }
                })
                UIButtonOutlined(text: "Change Format", symbol: "text.book.closed", fill: .black, color: UIColor(named: "AccentGray")!, action: {
                    withAnimation {
                        self.activeView = .format
                    }
                })
                UIButtonOutlined(text: "Change Players", symbol: "person.2", fill: .black, color: UIColor(named: "AccentGray")!, action: {
                    withAnimation {
                        self.activeView = .player
                    }
                })
                UIButton(text: "End Game", symbol: "xmark", color: UIColor(named: "PrimaryRed") ?? .systemGray, action: {
                    dismissModal()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        endGame()
                    }
                })
            }
            .frame(maxWidth: 300)
        }
    }
}

enum ActiveSettingsView {
    case home
    case roll
    case timer
    case layout
    case format
    case player
}

struct GameSettingsDialog: View {
    @Binding var open: Bool
    
    var endGame: () -> ()

    @State private var overlayOpacity: CGFloat = 0
    @State private var dialogOpacity: CGFloat = 0
    @State private var dialogOffset: CGFloat = 0.75
    
    @State private var activeView: ActiveSettingsView = .home
    
    var body: some View {
        ZStack {
            Color.black.opacity(overlayOpacity)
                .onTapGesture {
                    dismissModal()
                }
            
            VStack {
                switch (activeView) {
                    case .home:
                        GameSettingsHomeView(endGame: endGame, dismissModal: dismissModal, activeView: $activeView)
                    case .roll:
                        DiceRollView()
                    case .timer:
                        TimerView()
                    case .layout:
                        LayoutSelectorView()
                    case .format:
                        FormatSelectorView()
                    case .player:
                        PlayerSelectorView()
                }
            }
            .frame(maxWidth: 300)
            .padding(30)
            .background(
                Color(.black)
                    .overlay(LinearGradient(colors: [.white.opacity(0.05), .clear], startPoint: .top, endPoint: .bottom))
            )
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 15)
            .opacity(dialogOpacity)
            .scaleEffect(dialogOffset)
            .onAppear {
                UIApplication.shared.isIdleTimerDisabled = true

                withAnimation {
                    self.overlayOpacity = 0.5
                    self.dialogOpacity = 1
                    self.dialogOffset = 1.1
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation {
                            self.dialogOffset = 1
                        }
                    }
                }
            }
            .onDisappear {
                UIApplication.shared.isIdleTimerDisabled = false
            }
        }
    }
    
    func dismissModal() {
        withAnimation {
            self.overlayOpacity = 0
            self.dialogOpacity = 0
            self.dialogOffset = 0.75
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            open.toggle()
        }
    }
}
