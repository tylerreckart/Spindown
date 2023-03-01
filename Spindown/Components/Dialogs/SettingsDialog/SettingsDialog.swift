//
//  SettingsDialog.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/2/23.
//

import SwiftUI

enum ActiveSettingsView {
    case home
    case roll
    case timer
    case layout
    case player
    case playerCustomization
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
    
    @Binding var activeView: ActiveSettingsView
    
    var playerCount: Int
    
    @State private var showRulesSheet: Bool = false

    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Text("Game Settings")
                    .font(.system(size: 24, weight: .black))
                    .foregroundColor(Color.white)
                Spacer()
            }
            
            VStack(spacing: 15) {
                HorizontalControlRow(activeView: $activeView, showRulesSheet: $showRulesSheet)
                if (self.playerCount != 1) {
                    UIButtonOutlined(
                        text: "Change Layout",
                        symbol: "uiwindow.split.2x1",
                        fill: UIColor(named: "DeepGray")!,
                        color: UIColor(named: "AccentGray")!,
                        action: {
                            withAnimation {
                                self.activeView = .layout
                            }
                        }
                    )
                }
                UIButtonOutlined(
                    text: "Change Players",
                    symbol: "person.2",
                    fill: UIColor(named: "DeepGray")!,
                    color: UIColor(named: "AccentGray")!,
                    action: {
                        withAnimation {
                            self.activeView = .player
                        }
                    }
                )
                UIButton(
                    text: "End Game",
                    symbol: "xmark",
                    color: UIColor(named: "PrimaryRed")!,
                    action: endGame
                )
            }
        }
        .sheet(isPresented: $showRulesSheet) {
            RulesSheet()
        }
        .transition(
            .asymmetric(
                insertion: .push(from: .leading).combined(with: .opacity),
                removal: .push(from: .trailing).combined(with: .opacity)
            )
        )
    }
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
    @State private var selectedPlayer: Participant?
    
    var body: some View {
        Dialog(content: {
            VStack {
                switch (activeView) {
                    case .home:
                        GameSettingsHomeView(
                            endGame: endGame,
                            activeView: $activeView,
                            playerCount: self.players.count
                        )
                    case .roll:
                        DiceRollView(activeView: $activeView)
                    case .timer:
                        GameTimer(activeView: $activeView)
                    case .layout:
                        LayoutSelectorView(
                            activeView: $activeView,
                            selectedLayout: $selectedLayout,
                            playerCount: self.players.count
                        )
                    case .player:
                        PlayerSelectorView(
                            activeView: $activeView,
                            players: $players,
                            selectedPlayer: $selectedPlayer
                        )
                case .playerCustomization:
                        PlayerCustomizationContext(
                            customize: true,
                            savePlayer: savePlayer,
                            dismiss: dismissPlayerCustomizer,
                            selectedPlayer: selectedPlayer
                        )
                }
            }
            .onDisappear {
                self.activeView = .home
            }
        }, maxWidth: 300, open: $open)
    }
    
    func savePlayer(uid: UUID, name: String, color: UIColor) -> Void {
        if (self.selectedPlayer != nil) {
            var index = self.players.firstIndex(where: { $0.uid == self.selectedPlayer!.uid })

            self.selectedPlayer!.name = name
            self.selectedPlayer!.color = color
            
            withAnimation {
                self.players[index!] = self.selectedPlayer!
            }
        }
        
        withAnimation {
            self.activeView = .player
        }
    }

    func dismissPlayerCustomizer() -> Void {
        withAnimation {
            self.activeView = .player
        }
    }
}
