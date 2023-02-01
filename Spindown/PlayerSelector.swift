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
                    VStack {
                        Text("Players")
                            .font(.system(size: 32, weight: .black))
                        Text("Choose the number of players")
                            .font(.system(size: 16))
                            .foregroundColor(Color(.systemGray))
                    }
                    .padding(.bottom)
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            setNumPlayers(2)
                            setupStep += 1
                        }) {
                            NumberMenuOption(text: "2", textColor: .white, background: .systemGray6)
                        }.padding()
                        
                        Button(action: {
                            setNumPlayers(3)
                            setupStep += 1
                        }) {
                            NumberMenuOption(text: "3", textColor: .white, background: .systemGray6)
                        }.padding()
                        
                        Spacer()

                        Button(action: {
                            setNumPlayers(4)
                            setupStep += 1
                        }) {
                            NumberMenuOption(text: "4", textColor: .white, background: .systemGray6)
                        }.padding()
                        
                        Button(action: {
                            setNumPlayers(5)
                            setupStep += 1
                        }) {
                            NumberMenuOption(text: "5", textColor: .white, background: .systemGray6)
                        }.padding()
                        
                        Button(action: {
                            setNumPlayers(6)
                            setupStep += 1
                        }) {
                            NumberMenuOption(text: "6", textColor: .white, background: .systemGray6)
                        }.padding()
                        
                        Spacer()
                    }
                }
                .padding()
                .cornerRadius(18)
                .shadow(color: Color.black.opacity(0.1), radius: 20)
                
                MenuOptionOutlined(text: "Custom Players")
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: 480)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

