//
//  SavedPlayersSelector.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/6/23.
//

import SwiftUI

struct SavedPlayersSelector: View {
    var setPlayers: () -> ()
    
    @State private var players: [Participant] = []

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
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
                PlayerList(players: $players)
                
                UIButtonOutlined(
                    text: "Add Player",
                    symbol: "plus",
                    fill: .black,
                    color: UIColor(named: "AccentGray")!,
                    action: {}
                )
                UIButton(
                    text: "Start Game",
                    color: players.count > 0 ? UIColor(named: "PrimaryBlue")! : UIColor(named: "AccentGrayDarker")!,
                    action: {}
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
    }
}

struct SavedPlayersSelector_Previews: PreviewProvider {
    @State private static var setupStep: Double = 0
    
    static func setPlayers() {}

    static var previews: some View {
        SavedPlayersSelector(
            setPlayers: setPlayers
        ).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
