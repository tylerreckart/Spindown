//
//  PlayerList.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/6/23.
//

import SwiftUI

struct PlayerList: View {
    @Binding var players: [Participant]
    @Binding var startingLifeTotal: Int
    var savedPlayers: FetchedResults<Player>
    @Binding var selectedPlayer: Participant?
    @Binding var showDialog: Bool
    
    @State private var showMaxPlayerCountAlert: Bool = false
    @State private var contentSize: CGSize?

    var body: some View {
        VStack {
            if (savedPlayers.count > 0) {
                ScrollView {
                        VStack(spacing: 0) {
                            ForEach(self.savedPlayers, id: \.self) { player in
                                let index = self.savedPlayers.firstIndex(where: { $0.uid == player.uid })
                                let activeIndex = self.players.firstIndex(where: { $0.uid == player.uid })
                                
                                Button(action: {
                                    if (activeIndex == nil) {
                                        mapSavedPlayerToParticipantModel(player)
                                    } else {
                                        removeSavedPlayerFromParticipantModel(player)
                                    }
                                }) {
                                    HStack {
                                        if (activeIndex == nil) {
                                            Image(systemName: "circle")
                                                .foregroundColor(Color.white)
                                        } else {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(Color.white)
                                        }
                                        Text(player.name!)
                                            .foregroundColor(Color.white)
                                        Spacer()
                                        Button(action: {
                                            let remappedTarget = Participant()
                                            remappedTarget.uid = player.uid!
                                            remappedTarget.name = player.name!
                                            remappedTarget.color = NSKeyedUnarchiver.unarchiveObject(with: player.color!) as! UIColor
                                            self.selectedPlayer = remappedTarget
                                            withAnimation {
                                                self.showDialog.toggle()
                                            }
                                        }) {
                                            Image(systemName: "pencil.circle.fill")
                                                .foregroundColor(Color.white)
                                        }
                                    }
                                    .font(.system(size: 18, weight: .black))
                                    .padding()
                                    .background(
                                        (index ?? 0) % 2 == 0
                                        ? Color(UIColor(named: "AccentGray")!).opacity(0.25)
                                        : Color(UIColor(named: "AccentGrayDarker")!).opacity(0.25)
                                    )
                                }
                            }
                        }
                        .cornerRadius(4)
                        .overlay(
                            GeometryReader { geo in
                                Color.clear
                                    .onAppear {
                                        contentSize = geo.size
                                    }
                                    .onChange(of: savedPlayers.count) { newState in
                                        contentSize = geo.size
                                    }
                            }
                        )
                }
                .frame(maxWidth: .infinity, maxHeight: self.savedPlayers.count > 3 ? 200 : contentSize?.height)
                .padding(6)
                .background(.black)
                .cornerRadius(8)
            } else {
                VStack(alignment: .center) {
                    Text("Add players to get started!")
                        .frame(maxWidth: .infinity, maxHeight: 60)
                        .padding(4)
                        .background(Color(UIColor(named: "DeepGray") ?? .systemGray))
                        .cornerRadius(4)
                }
                .frame(maxWidth: .infinity)
                .padding(6)
                .background(.black)
                .cornerRadius(8)
            }
        }
        .padding(4)
        .background(Color(UIColor(named: "AccentGrayDarker") ?? .systemGray))
        .cornerRadius(12)
        .alert(isPresented: $showMaxPlayerCountAlert) {
            Alert(title: Text("Oops!"),
                  message: Text("Spindown only supports up to six active players in a single game. To add more players, please remove existing selected players."),
                  dismissButton: .default(Text("OK")))
        }
    }
    
    func removeSavedPlayerFromParticipantModel(_ savedPlayer: Player) {
        let targetIndex = self.players.firstIndex(where: { $0.uid == savedPlayer.uid })
        
        if (targetIndex != nil) {
            self.players.remove(at: targetIndex!)
        }
    }
    
    func mapSavedPlayerToParticipantModel(_ savedPlayer: Player) {
        if (self.players.count == 6) {
            self.showMaxPlayerCountAlert.toggle()
        } else {
            let player = Participant()
            player.uid = savedPlayer.uid!
            player.name = savedPlayer.name!
            player.lifeTotal = self.startingLifeTotal
            player.color = NSKeyedUnarchiver.unarchiveObject(with: savedPlayer.color!) as! UIColor
            self.players.append(player)
        }
    }
}

