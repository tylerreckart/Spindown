//
//  PlayersSelector.swift
//  Spindown
//
//  Created by Tyler Reckart on 1/29/23.
//

import SwiftUI

struct PlayersSelector: View {
    @Binding var currentPage: Page

    var setNumPlayers: (Int) -> ()
    var setUsedSavedPlayers: () -> ()
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    withAnimation {
                        self.currentPage = .lifeTotal
                    }
                }) {
                    Image(systemName: "arrow.backward")
                        .font(.system(size: 18, weight: .black))
                    Text("Go Back")
                        .font(.system(size: 18, weight: .black))
                }
                Spacer()
            }
            .foregroundColor(.white)
            .padding()
    
            Spacer()

            VStack {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    Text("Players")
                        .font(.system(size: 64, weight: .black))
                        .foregroundColor(.white)
                        .padding(.bottom, 5)
                    Text("Choose the number of players.")
                        .font(.system(size: 20))
                        .foregroundColor(Color(.systemGray))
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                } else {
                    Text("Players")
                        .font(.system(size: 48, weight: .black))
                        .foregroundColor(.white)
                        .padding(.bottom, 5)
                    Text("Choose the number of players.")
                        .font(.system(size: 16))
                        .foregroundColor(Color(.systemGray))
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                }
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
                Text("Select or add saved players.")
                    .font(.system(size: 16))
                    .foregroundColor(Color(.systemGray))
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                UIButtonOutlined(
                    text: "Saved Players",
                    fill: .black,
                    color: UIColor(named: "AccentGray")!,
                    action: setUsedSavedPlayers
                )
                .frame(maxWidth: .infinity)
                .padding(0)
            }
            .frame(maxWidth: 300)
            
            Spacer()
        }
        .transition(.push(from: .trailing))
    }
}

