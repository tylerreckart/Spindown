//
//  PlayerSelector.swift
//  Spindown
//
//  Created by Tyler Reckart on 1/29/23.
//

import SwiftUI

struct PlayerSelector: View {
    @Binding var setupStep: Int

    var setNumPlayers: (Int) -> ()
    
    var body: some View {
        VStack {
            Spacer()

            VStack {
                Text("Players")
                    .font(.system(size: 64, weight: .black))
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
                Text("Select the number of players or choose to play with saved players.")
                    .font(.system(size: 20))
                    .foregroundColor(Color(.systemGray))
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
            }
            .padding(.bottom)
            .frame(maxWidth: 320)

            VStack {
                HStack {
                    UIButton(text: "1", symbol: nil, color: UIColor(named: "AccentGrayDarker")!, action: {
                        setNumPlayers(1)
                        setupStep += 1
                    })
                    UIButton(text: "2", symbol: nil, color: UIColor(named: "AccentGrayDarker")!, action: {
                        setNumPlayers(2)
                        setupStep += 1
                    })
                    UIButton(text: "3", symbol: nil, color: UIColor(named: "AccentGrayDarker")!, action: {
                        setNumPlayers(3)
                        setupStep += 1
                    })
                }
                HStack {
                    UIButton(text: "4", symbol: nil, color: UIColor(named: "AccentGrayDarker")!, action: {
                        setNumPlayers(4)
                        setupStep += 1
                    })
                    UIButton(text: "5", symbol: nil, color: UIColor(named: "AccentGrayDarker")!, action: {
                        setNumPlayers(5)
                        setupStep += 1
                    })
                    UIButton(text: "6", symbol: nil, color: UIColor(named: "AccentGrayDarker")!, action: {
                        setNumPlayers(6)
                        setupStep += 1
                    })
                }
                UIButtonOutlined(text: "Custom Players", symbol: nil, fill: .black, color: UIColor(named: "AccentGray")!, action: {
                    setupStep += 1
                })
            }
            .frame(maxWidth: 280)
            
            Spacer()
        }
    }
}

