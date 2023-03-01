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

    var body: some View {
        VStack {
            if (savedPlayers.count > 0) {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(self.savedPlayers, id: \.self) { player in
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
                                }
                                .font(.system(size: 18, weight: .black))
                                .padding()
                                .background(Color(UIColor(named: "DeepGray") ?? .systemGray5))
                            }
                        }
                    }
                    .cornerRadius(4)
                }
                .frame(maxWidth: .infinity, maxHeight: 200)
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
    }
    
    func removeSavedPlayerFromParticipantModel(_ savedPlayer: Player) {
        let targetIndex = self.players.firstIndex(where: { $0.uid == savedPlayer.uid })
        
        if (targetIndex != nil) {
            self.players.remove(at: targetIndex!)
        }
    }
    
    func mapSavedPlayerToParticipantModel(_ savedPlayer: Player) {
        let player = Participant()
        player.uid = savedPlayer.uid!
        player.name = savedPlayer.name!
        player.lifeTotal = self.startingLifeTotal
        player.color = NSKeyedUnarchiver.unarchiveObject(with: savedPlayer.color!) as! UIColor
        self.players.append(player)
    }
}

