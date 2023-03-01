//
//  SavedPlayersSelector.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/6/23.
//

import SwiftUI

struct SavedPlayersSelector: View {
    @FetchRequest(
      entity: Player.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \Player.uid, ascending: true)
      ]
    ) var savedPlayers: FetchedResults<Player>

    @Binding var currentPage: Page
    @Binding var startingLifeTotal: Int
    @Binding var players: [Participant]
    var startGame: () -> ()
    
    @State private var showCustomizationDialog: Bool = false
    @State private var reverseAnimation: Bool = false

    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 0) {
                OnboardingBackButton(action: {
                    self.reverseAnimation.toggle()
                    withAnimation {
                        self.currentPage = .players
                    }
                })

                Spacer()
                
                VStack {
                    Text("Saved Players")
                        .font(.system(size: UIDevice.current.userInterfaceIdiom == .pad ? 64 : 48, weight: .black))
                        .foregroundColor(.white)
                        .padding(.bottom, 5)
                    Text("Select or add saved players.")
                        .font(.system(size: UIDevice.current.userInterfaceIdiom == .pad ? 20 : 16))
                        .foregroundColor(Color(.systemGray))
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                }
                .padding(.bottom, 20)
                
                VStack(spacing: 20) {
                    PlayerList(players: $players, startingLifeTotal: $startingLifeTotal, savedPlayers: savedPlayers)
                    
                    UIButtonOutlined(
                        text: "Add Player",
                        symbol: "plus",
                        fill: .black,
                        color: UIColor(named: "AccentGray")!,
                        action: {
                            withAnimation {
                                self.showCustomizationDialog.toggle()
                            }
                        }
                    )
                    UIButton(
                        text: "Start Game",
                        color: players.count > 0 ? UIColor(named: "PrimaryBlue")! : UIColor(named: "AccentGrayDarker")!,
                        action: startGame
                    )
                    .opacity(players.count > 0 ? 1 : 0.5)
                    .disabled(players.count == 0)
                }
                .frame(maxWidth: 400)
                
                Spacer()
            }
            .foregroundColor(Color.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .padding(.horizontal)
            
            PlayerCustomizationDialog(isOpen: $showCustomizationDialog)
        }
        .transition(
            .asymmetric(
                insertion: .push(from: self.reverseAnimation != true ? .trailing : .leading),
                removal: .push(from: .trailing)
            )
        )
    }
}
