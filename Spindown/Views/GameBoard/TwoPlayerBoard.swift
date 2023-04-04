//
//  TwoPlayerBoard.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/1/23.
//

import SwiftUI

enum BoardLayout {
    case facingPortrait
    case facingLandscape
    case tandem
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct TwoPlayerGameBoard: View {
    @Binding var players: [Participant]
    @Binding var numPlayersRemaining: Int
    @Binding var selectedPlayer: Participant?
    @Binding var selectedLayout: BoardLayout
    var showLifeTotalCalculatorForPlayer: () -> ()
    
    var updateLifeTotal: (Participant, Int) -> Void
    @Binding var showSettingsDialog: Bool

    var body: some View {
        if (self.players.count == 2) {
            ZStack {
                VStack(spacing: 0) {
                    PlayerTile(
                        player: players[1],
                        updateLifeTotal: updateLifeTotal,
                        showLifeTotalCalculator: showLifeTotalCalculatorForPlayer,
                        selectedPlayer: $selectedPlayer
                    )
                    .cornerRadius(16, corners: [.topLeft, .topRight])
                    .rotationEffect(Angle(degrees: 180))
                    
                    Rectangle().fill(.black).frame(maxWidth: .infinity, maxHeight: 8)
                    
                    PlayerTile(
                        player: players[0],
                        updateLifeTotal: updateLifeTotal,
                        showLifeTotalCalculator: showLifeTotalCalculatorForPlayer,
                        selectedPlayer: $selectedPlayer
                    )
                    .cornerRadius(16, corners: [.topLeft, .topRight])
                }
                
                Button(action: {
                    withAnimation(.spring(response: 0.55, dampingFraction: 0.5, blendDuration: 0)) {
                        self.showSettingsDialog.toggle()
                    }
                    
                }) {
                    Image("Pin")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 60)
                        .rotationEffect(Angle(degrees: 10))
                        .shadow(radius: 3)
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
