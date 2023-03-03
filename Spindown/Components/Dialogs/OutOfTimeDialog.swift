//
//  OutOfTimeDialog.swift
//  Spindown
//
//  Created by Tyler Reckart on 3/3/23.
//

import SwiftUI

struct OutOfTimeDialog: View {
    @Binding var open: Bool
    
    var endGame: () -> ()
    var dismiss: () -> ()
    
    var body: some View {
        Dialog(content: {
            VStack {
                VStack(spacing: 0) {
                    Text("Time's Up!")
                        .font(.system(size: 28, weight: .black))
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 10)
                    
                    Text("The timer set for this game has expired. You may choose to end the game or continue playing.")
                        .font(.system(size: 16))
                        .multilineTextAlignment(.center)
                        .lineSpacing(2)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 20)
                }
                
                VStack(spacing: 20) {
                    UIButton(
                        text: "End Game",
                        color: UIColor(named: "PrimaryRed")!,
                        action: endGame
                    )
                    
                    UIButtonOutlined(
                        text: "Keep Playing",
                        symbol: "arrow.clockwise",
                        fill: UIColor(named: "DeepGray")!,
                        color: UIColor(named: "AccentGray")!,
                        action: dismiss
                    )
                }
            }
        }, maxWidth: 300, open: $open)
    }
}
