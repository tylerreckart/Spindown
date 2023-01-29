//
//  ContentView.swift
//  Spindown
//
//  Created by Tyler Reckart on 1/29/23.
//

import SwiftUI
import CoreData

struct MenuOptionOutlined: View {
    var text: String

    var body: some View {
        Text(text)
            .frame(maxWidth: .infinity, maxHeight: 40)
            .foregroundColor(.primary)
            .padding()
            .background(.background)
            .cornerRadius(8)
            .padding(5)
            .background(Color(.systemGray5))
            .cornerRadius(12)
            .padding(5)
    }
}

struct MenuOption: View {
    var text: String

    var body: some View {
        Text(text)
            .frame(maxWidth: .infinity, maxHeight: 40)
            .foregroundColor(.primary)
            .padding()
            .background(Color(.systemGray5))
            .cornerRadius(12)
            .padding(5)
    }
}

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
                .padding(.bottom)

                HStack {
                    Button(action: {
                        setNumPlayers(1)
                        setupStep += 1
                    }) {
                        MenuOption(text: "1")
                    }
                    Button(action: {
                        setNumPlayers(2)
                        setupStep += 1
                    }) {
                        MenuOption(text: "2")
                    }
                    Button(action: {
                        setNumPlayers(3)
                        setupStep += 1
                    }) {
                        MenuOption(text: "3")
                    }
                }
                
                HStack {
                    Button(action: {
                        setNumPlayers(4)
                        setupStep += 1
                    }) {
                        MenuOption(text: "4")
                    }
                    Button(action: {
                        setNumPlayers(5)
                        setupStep += 1
                    }) {
                        MenuOption(text: "5")
                    }
                    Button(action: {
                        setNumPlayers(6)
                        setupStep += 1
                    }) {
                        MenuOption(text: "6")
                    }
                }
            }
            .frame(maxWidth: 400)
            .padding()
            .background(.background)
            .cornerRadius(18)
            .shadow(color: Color.black.opacity(0.1), radius: 20)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct Format: Hashable {
    public static func == (lhs: Format, rhs: Format) -> Bool {
        return lhs.name == rhs.name
    }

    var name: String
    var startingLifeTotal: Int16
}

struct FormatSelector: View {
    @Binding var setupStep: Int

    var setFormat: (Format) -> ()

    var body: some View {
        ZStack {
            Color.black.opacity(0.2)
            
            VStack {
                VStack {
                    Text("Format")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                    Text("Choose a format or create your own")
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(Color(.systemGray))
                }
                .padding(.bottom)

                HStack {
                    Button(action: {
                        setFormat(Format(name: "Commander", startingLifeTotal: 40))
                        setupStep += 1
                    }) {
                        MenuOption(text: "Commander")
                    }
                    Button(action: {
                        setFormat(Format(name: "Standard", startingLifeTotal: 20))
                        setupStep += 1
                    }) {
                        MenuOption(text: "Standard")
                    }
                    Button(action: {
                        setFormat(Format(name: "Modern", startingLifeTotal: 20))
                        setupStep += 1
                    }) {
                        MenuOption(text: "Modern")
                    }
                }
                
                HStack {
                    Button(action: {
                        setFormat(Format(name: "Legacy", startingLifeTotal: 20))
                        setupStep += 1
                    }) {
                        MenuOption(text: "Legacy")
                    }
                    Button(action: {
                        setFormat(Format(name: "Pioneer", startingLifeTotal: 20))
                        setupStep += 1
                    }) {
                        MenuOption(text: "Pioneer")
                    }
                    Button(action: {
                        setFormat(Format(name: "Draft", startingLifeTotal: 20))
                        setupStep += 1
                    }) {
                        MenuOption(text: "Draft")
                    }
                }
                
                MenuOptionOutlined(text: "Custom Format")
            }
            .frame(maxWidth: 600)
            .padding()
            .background(.background)
            .cornerRadius(18)
            .shadow(color: Color.black.opacity(0.1), radius: 20)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

class Participant: ObservableObject, Equatable, Identifiable, Hashable {
    var uid: UUID = UUID()
    var name: String = ""
    var currentLifeTotal: Int16 = 0
    
    static func == (lhs: Participant, rhs: Participant) -> Bool {
        return lhs.uid == rhs.uid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
}

struct PlayerTile: View {
    var player: Participant
    
    @State private var currentLifeTotal: Int16 = 0
    
    var body: some View {
        ZStack {
            VStack {
                Button(action: {
                    self.currentLifeTotal = self.currentLifeTotal + 1
                }) {
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(maxHeight: .infinity)
                        .cornerRadius(12)
                }
                
                Button(action: {
                    self.currentLifeTotal = self.currentLifeTotal - 1
                }) {
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(maxHeight: .infinity)
                        .cornerRadius(12)
                }
            }
            
            VStack {
                Spacer()
                Text(player.name)
                    .font(.caption)
                Text("\(self.currentLifeTotal)")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                Spacer()
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(.primary)
        .padding()
        .background(Color(.systemGray5))
        .cornerRadius(12)
        .padding(5)
        .onAppear {
            self.currentLifeTotal = player.currentLifeTotal
        }
    }
}

struct GameBoard: View {
    @Binding var players: [Participant]
    
    var body: some View {
        VStack {
            ForEach(players, id: \.self) { player in
                PlayerTile(player: player)
            }
        }
        .padding()
    }
}

struct ContentView: View {
    @State private var playerCount: Int = 1
    @State private var format: Format?
    @State private var setupStep: Int = 0
    @State private var setupComplete: Bool = false
    @State private var players: [Participant] = []
    
    var body: some View {
        ZStack {
            if (self.setupComplete == false) {
                if (self.setupStep == 0) {
                    VStack {
                        Spacer()
                        
                        if (self.setupStep == 0) {
                            Button(action: {
                                self.setupStep += 1
                            }) {
                                Text("Start Game")
                            }
                        }
                        
                        Spacer()
                    }
                }
                
                if (self.setupStep == 1) {
                    FormatSelector(setupStep: $setupStep, setFormat: selectFormat)
                }
                
                if (self.setupStep == 2) {
                    PlayerSelector(setupStep: $setupStep, setNumPlayers: selectPlayerCount)
                }
            }
            
            if (self.setupComplete) {
                VStack {
                    HStack {
                        Text("Player Count: \(playerCount)")
                        Spacer()
                        Text("Format: \(format?.name ?? "")")
                    }
                    .padding()
                    
                    GameBoard(players: $players)
                }
            }
        }
        .onChange(of: setupStep) { newState in
            print("setup step change handler")
            if (setupStep == 3) {
                // Reset state for future game setup.
                self.setupStep = 0
                // Set completion state for board draw.
                self.setupComplete = true
            }
        }
        .onChange(of: setupComplete) { newState in
            print("setup completion change handler")
            if (self.setupComplete == true && self.players.count == 0) {
                for count in 1..<self.playerCount + 1 {
                    let player = Participant()
                    player.name = "Player \(count)"
                    player.currentLifeTotal = format?.startingLifeTotal ?? 20
                    self.players.append(player)
                }
            } else {
                self.players = []
            }
        }
        .onChange(of: players) { newState in
            print("players change handler")
            print(newState)
        }
    }
    
    private func selectFormat(_ selectedFormat: Format) -> Void {
        if (self.format == nil) {
            self.format = selectedFormat
        } else {
            self.format!.name = selectedFormat.name
            self.format!.startingLifeTotal = selectedFormat.startingLifeTotal
        }
    }
    
    private func selectPlayerCount(_ numPlayers: Int) {
        self.playerCount = numPlayers
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
