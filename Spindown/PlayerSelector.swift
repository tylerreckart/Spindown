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
        ZStack {
            Color.black.opacity(0.2)
            
            VStack {
                VStack {
                    Text("Players")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                    Text("Choose the number of players")
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(Color(.systemGray))
                }

                HStack {
                    Button(action: {
                        setNumPlayers(1)
                        setupStep += 1
                    }) {
                        MenuOption(text: "1", textColor: .white, background: .systemPurple)
                    }
                    Button(action: {
                        setNumPlayers(2)
                        setupStep += 1
                    }) {
                        MenuOption(text: "2", textColor: .white, background: .systemBlue)
                    }
                    Button(action: {
                        setNumPlayers(3)
                        setupStep += 1
                    }) {
                        MenuOption(text: "3", textColor: .white, background: .systemGreen)
                    }
                }
                
                HStack {
                    Button(action: {
                        setNumPlayers(4)
                        setupStep += 1
                    }) {
                        MenuOption(text: "4", textColor: .white, background: .systemYellow)
                    }
                    Button(action: {
                        setNumPlayers(5)
                        setupStep += 1
                    }) {
                        MenuOption(text: "5", textColor: .white, background: .systemOrange)
                    }
                    Button(action: {
                        setNumPlayers(6)
                        setupStep += 1
                    }) {
                        MenuOption(text: "6", textColor: .white, background: .systemRed)
                    }
                }
                
                MenuOptionOutlined(text: "Select Saved Players")
            }
            .frame(maxWidth: 400)
            .padding()
            .cornerRadius(18)
            .shadow(color: Color.black.opacity(0.1), radius: 20)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

