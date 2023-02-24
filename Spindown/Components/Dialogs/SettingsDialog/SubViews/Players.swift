//
//  PlayersSelector.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/22/23.
//

import SwiftUI

struct PlayerSelectorView: View {
    @Binding var activeView: ActiveSettingsView
    @Binding var players: [Participant]
    
    @State private var localPlayerList: [Participant] = []

    var body: some View {
        VStack {
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
                                
                                HStack {
                                    Button(action: {
                                        withAnimation {
                                            if (activeIndex != nil) {
                                                removePlayer(player)
                                            } else {
                                                addPlayer(player)
                                            }
                                        }
                                    }) {
                                        Image(systemName: activeIndex != nil ? "checkmark.circle.fill" : "circle")
                                            .font(.system(size: 18, weight: .black))
                                            .foregroundColor(Color.white)
                                        Text(player.name)
                                            .foregroundColor(Color.white)
                                        Spacer()
                                    }
                                    Image(systemName: "pencil.circle.fill")
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
        .transition(
            .asymmetric(
                insertion: .push(from: .trailing).combined(with: .opacity),
                removal: .push(from: .leading).combined(with: .opacity)
            )
        )
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
        
        if (index != nil && index! < players.count) {
            self.players.insert(player, at: index!)
        } else if (index != nil && index! > players.count) {
            self.players.append(player)
        }
    }
}
