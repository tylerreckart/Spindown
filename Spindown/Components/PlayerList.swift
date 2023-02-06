//
//  PlayerList.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/6/23.
//

import SwiftUI

struct PlayerList: View {
    @Binding var players: [Participant]

    var body: some View {
        VStack {
            if (players.count > 0) {
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
                .frame(maxWidth: .infinity, maxHeight: 60)
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
}

