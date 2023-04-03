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
                        player: players[0],
                        updateLifeTotal: updateLifeTotal,
                        showLifeTotalCalculator: showLifeTotalCalculatorForPlayer,
                        selectedPlayer: $selectedPlayer
                    )
                    .cornerRadius(16, corners: [.topLeft, .topRight])
                    .rotationEffect(Angle(degrees: 180))
                    
                    Rectangle().fill(.black).frame(maxWidth: .infinity, maxHeight: 8)
                    
                    PlayerTile(
                        player: players[1],
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
                    ZStack(alignment: .center) {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 56, weight: .thin))
                            .shadow(radius: 4, y: 2)
                            .foregroundStyle(.white)
                        
                        Image(systemName: "circle.fill")
                            .font(.system(size: 46, weight: .light))
                            .foregroundStyle(
                                .black
                            )
                        
                        Image(systemName: "gamecontroller.fill")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.2), radius: 2, y: 1)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
