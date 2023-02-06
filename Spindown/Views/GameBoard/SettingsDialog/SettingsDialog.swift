//
//  SettingsDialog.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/2/23.
//

import SwiftUI

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

struct FormatSelectorView: View {
    var body: some View {
        Text("Format")
    }
}

struct PlayerSelectorView: View {
    @Binding var activeView: ActiveSettingsView
    @Binding var players: [Participant]

    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Image(systemName: "person.2")
                    .foregroundColor(Color.white)
                    .font(.system(size: 24, weight: .black))
                    .padding(.trailing, 4)
                Text("Change Players")
                    .font(.system(size: 24, weight: .black))
                    .foregroundColor(Color.white)
                Spacer()
            }
            VStack {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(self.players, id: \.self) { player in
                            Button(action: {}) {
                                HStack {
                                    Image(systemName: player.symbol != nil ? player.symbol! : "person.circle.fill")
                                        .foregroundColor(Color.white)
                                    Text(player.name)
                                        .foregroundColor(Color.white)
                                    Spacer()
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Color.white)
                                }
                                .font(.system(size: 18, weight: .black))
                                .padding()
                                .background(Color(UIColor(named: "DeepGray") ?? .systemGray5))
                            }
                        }
                    }
                    .cornerRadius(4)
                }
                .padding(6)
                .background(.black)
                .cornerRadius(8)
            }
            .padding(4)
            .background(Color(UIColor(named: "AccentGrayDarker") ?? .systemGray))
            .cornerRadius(12)
            .frame(maxHeight: 220)
        }
        .frame(width: 300)
        
        VStack {
            UIButtonOutlined(text: "Save", fill: .black, color: UIColor(named: "AccentGray") ?? .systemGray, action: {
                withAnimation {
                    self.activeView = .home
                }
                
            })
        }
        .frame(maxWidth: 300)
        .padding(.top, 15)
    }
}

struct HorizontalControlRow: View {
    @Binding var activeView: ActiveSettingsView
    @Binding var showRulesSheet: Bool

    var body: some View {
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
            UIButtonStacked(text: "Rules", symbol: "book", color: UIColor(named: "AccentGrayDarker") ?? .systemGray, action: {
                self.showRulesSheet.toggle()
            })
        }
    }
}

struct GameSettingsHomeView: View {
    var endGame: () -> ()
    var dismissModal: () -> ()
    
    @Binding var activeView: ActiveSettingsView
    
    var playerCount: Int
    
    @State private var showRulesSheet: Bool = false

    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Text("Settings")
                    .font(.system(size: 24, weight: .black))
                    .foregroundColor(Color.white)
                Spacer()
            }
            
            VStack(spacing: 15) {
//                HorizontalControlRow(activeView: $activeView, showRulesSheet: $showRulesSheet)
                
                UIButtonOutlined(text: "Game Timer", symbol: "stopwatch", fill: .black, color: UIColor(named: "AccentGray")!, action: {
                    withAnimation {
                        self.activeView = .format
                    }
                })
                if (self.playerCount != 1) {
                    UIButtonOutlined(
                        text: "Change Layout",
                        symbol: "uiwindow.split.2x1",
                        fill: .black,
                        color: UIColor(named: "AccentGray")!,
                        action: {
                            withAnimation {
                                self.activeView = .layout
                            }
                        }
                    )
                }

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
//        .sheet(isPresented: $showRulesSheet, onDismiss: { self.showRulesSheet = false }) {
//            RulesSheet()
//        }
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
    @Binding var selectedLayout: BoardLayout
    @Binding var players: [Participant]
    
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
                        GameSettingsHomeView(
                            endGame: endGame,
                            dismissModal: dismissModal,
                            activeView: $activeView,
                            playerCount: self.players.count
                        )
                    case .roll:
                        DiceRollView()
                    case .timer:
                        TimerView()
                    case .layout:
                        LayoutSelectorView(
                            activeView: $activeView,
                            selectedLayout: $selectedLayout,
                            playerCount: self.players.count
                        )
                    case .format:
                        FormatSelectorView()
                    case .player:
                        PlayerSelectorView(activeView: $activeView, players: $players)
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
