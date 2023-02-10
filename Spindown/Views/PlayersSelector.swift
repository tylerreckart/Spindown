//
//  PlayersSelector.swift
//  Spindown
//
//  Created by Tyler Reckart on 1/29/23.
//

import SwiftUI

struct PlayersSelector: View {
    var setNumPlayers: (Int) -> ()
    
    var body: some View {
        VStack {
            Spacer()

            VStack {
                Text("Players")
                    .font(.system(size: 64, weight: .black))
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
                Text("Choose the number of players.")
                    .font(.system(size: 20))
                    .foregroundColor(Color(.systemGray))
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
            }
            .padding(.bottom)
            .frame(maxWidth: 320)

            VStack(spacing: 20) {
                HStack(spacing: 20) {
                    UIButtonTile(text: "1", symbol: nil, color: UIColor(named: "AccentGrayDarker")!, action: {
                        setNumPlayers(1)
                    })
                    UIButtonTile(text: "2", symbol: nil, color: UIColor(named: "AccentGrayDarker")!, action: {
                        setNumPlayers(2)
                    })
                    UIButtonTile(text: "3", symbol: nil, color: UIColor(named: "AccentGrayDarker")!, action: {
                        setNumPlayers(3)
                    })
                }
                HStack(spacing: 20) {
                    UIButtonTile(text: "4", symbol: nil, color: UIColor(named: "AccentGrayDarker")!, action: {
                        setNumPlayers(4)
                    })
                    UIButtonTile(text: "5", symbol: nil, color: UIColor(named: "AccentGrayDarker")!, action: {
                        setNumPlayers(5)
                    })
                    UIButtonTile(text: "6", symbol: nil, color: UIColor(named: "AccentGrayDarker")!, action: {
                        setNumPlayers(6)
                    })
                }
//                UIButtonOutlined(
//                    text: "Saved Players",
//                    symbol: nil,
//                    fill: .black,
//                    color: UIColor(named: "AccentGray")!,
//                    action: {
//                        setupStep += 0.5
//                    }
//                )
//                .padding(.top, 10)
            }
            .frame(maxWidth: 300)
            
            Spacer()
        }
    }
}

