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
    
    @State private var localPlayerList: [Participant] = []

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
                        ForEach(self.localPlayerList, id: \.self) { player in
                            let index = self.localPlayerList.firstIndex(where: { $0.id == player.id })
                            let activeIndex = self.players.firstIndex(where: { $0.id == player.id })
                            Button(action: {
                                withAnimation {
                                    if (activeIndex != nil) {
                                        removePlayer(player)
                                    } else {
                                        addPlayer(player)
                                    }
                                }
                            }) {
                                HStack {
                                    Image(systemName: activeIndex != nil ? "checkmark.circle.fill" : "circle")
                                        .font(.system(size: 18, weight: .black))
                                        .foregroundColor(Color.white)
                                    Text(player.name)
                                        .foregroundColor(Color.white)
                                    Spacer()
                                    Image(systemName: "pencil")
                                        .foregroundColor(Color.white)
                                        .font(.system(size: 18, weight: .black))
                                }
                                .font(.system(size: 18, weight: .black))
                                .padding()
                                .background(
                                    (index ?? 0) % 2 == 0
                                    ? Color(UIColor(named: "AccentGrayDarker")!).opacity(0.25)
                                    : Color(UIColor(named: "AccentGray")!).opacity(0.25)
                                )
                            }
                        }
                    }
                    .cornerRadius(4)
                }
                .padding(6)
                .background(Color(UIColor(named: "DeepGray")!))
                .cornerRadius(8)
            }
            .padding(4)
            .background(Color(UIColor(named: "AccentGrayDarker")!))
            .cornerRadius(12)
            .frame(maxHeight: 150)
        }
        
        VStack(spacing: 20) {
            UIButton(
                text: "Add Player",
                color: self.localPlayerList.count < 6 ? UIColor(named: "PrimaryRed")! : UIColor(named: "AccentGrayDarker")!,
                action: addNewPlayer
            )
            UIButtonOutlined(
                text: "Go Back",
                fill: UIColor(named: "DeepGray")!,
                color: UIColor(named: "AccentGray")!,
                action: {
                    withAnimation {
                        self.activeView = .home
                    }
                }
            )
        }
        .frame(maxWidth: 300)
        .padding(.top, 15)
        .onAppear {
            self.localPlayerList = self.players
        }
    }
    
    func addNewPlayer() -> Void {
        if (self.localPlayerList.count < 6) {
            let count = self.players.count
            let player = Participant()
            player.name = "Player \(count + 1)"
            player.lifeTotal = players[0].lifeTotal
            player.color = colors[count - 1]
            withAnimation {
                self.players.append(player)
            }
            self.localPlayerList.append(player)
        }
    }
    
    func removePlayer(_ player: Participant) -> Void {
        let index = self.players.firstIndex(where: { $0.id == player.id })
        
        self.players.remove(at: index!)
    }
    
    func addPlayer(_ player: Participant) -> Void {
        let index = self.localPlayerList.firstIndex(where: { $0.id == player.id })
        
        self.players.insert(player, at: index!)
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
                UIButtonOutlined(
                    text: "Game Timer",
                    symbol: "stopwatch",
                    fill: UIColor(named: "DeepGray")!,
                    color: UIColor(named: "AccentGray")!,
                    action: {
                        withAnimation {
                            self.activeView = .timer
                        }
                    }
                )
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
                        withAnimation(.easeInOut(duration: 0.6)) {
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
        .transition(
            .asymmetric(
                insertion: .push(from: .leading).combined(with: .opacity),
                removal: .push(from: .trailing).combined(with: .opacity)
            )
        )
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
                        DiceRollView()
                    case .timer:
                        GameTimer(activeView: $activeView)
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
            .onDisappear {
                self.activeView = .home
            }
        }, maxWidth: 300, open: $open)
    }
}
