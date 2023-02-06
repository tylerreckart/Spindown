//
//  SavedPlayersSelector.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/6/23.
//

import SwiftUI

struct SavedPlayersSelector: View {
    @Binding var setupStep: Double
    
    var setPlayers: () -> ()
    
    @State private var players: [Participant] = []

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer()

            VStack {
                Text("Saved Players")
                    .font(.system(size: 64, weight: .black))
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
                Text("Select or create saved players.")
                    .font(.system(size: 20))
                    .foregroundColor(Color(.systemGray))
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
            }
            .padding(.bottom, 25)
            
            VStack(spacing: 20) {
                PlayerList(players: $players)
                
                UIButtonOutlined(text: "Add Player", symbol: "plus", fill: .black, color: UIColor(named: "AccentGray") ?? .systemGray, action: {})
                UIButton(text: "Start Game", symbol: "play", color: UIColor(named: "PrimaryRed") ?? .systemGray, action: {})
                    .padding(.bottom, 5)
            }
            .frame(maxWidth: 400)

            
            Spacer()
        }
        .foregroundColor(Color.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
}

struct SavedPlayersSelector_Previews: PreviewProvider {
    @State private static var setupStep: Double = 0
    
    static func setPlayers() {}

    static var previews: some View {
        SavedPlayersSelector(
            setupStep: $setupStep,
            setPlayers: setPlayers
        ).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
