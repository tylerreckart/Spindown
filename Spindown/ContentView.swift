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
            .font(.system(size: 16, weight: .bold, design: .rounded))
            .frame(maxWidth: .infinity, maxHeight: 40)
            .foregroundColor(.primary)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(5)
    }
}

struct MenuOption: View {
    var text: String
    var textColor: UIColor = .white
    var background: UIColor

    var body: some View {
        Text(text)
            .font(.system(size: 16, weight: .black, design: .rounded))
            .foregroundColor(Color(textColor))
            .frame(maxWidth: .infinity, maxHeight: 40)
            .foregroundColor(.primary)
            .padding()
            .background(Color(background))
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

                HStack {
                    Button(action: {
                        setFormat(Format(name: "Commander", startingLifeTotal: 40))
                        setupStep += 1
                    }) {
                        MenuOption(text: "Commander", background: .systemGray5)
                    }
                    Button(action: {
                        setFormat(Format(name: "Standard", startingLifeTotal: 20))
                        setupStep += 1
                    }) {
                        MenuOption(text: "Standard", background: .systemGray5)
                    }
                    Button(action: {
                        setFormat(Format(name: "Modern", startingLifeTotal: 20))
                        setupStep += 1
                    }) {
                        MenuOption(text: "Modern", background: .systemGray5)
                    }
                }
                
                HStack {
                    Button(action: {
                        setFormat(Format(name: "Legacy", startingLifeTotal: 20))
                        setupStep += 1
                    }) {
                        MenuOption(text: "Legacy", background: .systemGray5)
                    }
                    Button(action: {
                        setFormat(Format(name: "Pioneer", startingLifeTotal: 20))
                        setupStep += 1
                    }) {
                        MenuOption(text: "Pioneer", background: .systemGray5)
                    }
                    Button(action: {
                        setFormat(Format(name: "Draft", startingLifeTotal: 20))
                        setupStep += 1
                    }) {
                        MenuOption(text: "Draft", background: .systemGray5)
                    }
                }
                
                MenuOptionOutlined(text: "Custom Format")
            }
            .frame(maxWidth: 600)
            .padding()
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
    var loser: Bool = false
    
    static func == (lhs: Participant, rhs: Participant) -> Bool {
        return lhs.uid == rhs.uid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
}

struct PlayerTile: View {
    var player: Participant
    var color: UIColor
    
    @Binding var numPlayersRemaining: Int
    
    @State private var currentLifeTotal: String = "0"
    @State private var loser: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                if (self.loser == false) {
                    Button(action: {
                        incrementLifeTotal()
                    }) {
                        Rectangle()
                            .fill(Color(color))
                            .frame(maxHeight: .infinity)
                            .cornerRadius(12)
                    }
                    
                    Button(action: {
                        decrementLifeTotal()
                    }) {
                        Rectangle()
                            .fill(Color(color))
                            .frame(maxHeight: .infinity)
                            .cornerRadius(12)
                    }
                }
            }
            
            VStack {
                Spacer()
                Text(player.name)
                    .font(.system(size: 24, weight: .regular, design: .rounded))
                if (self.loser == false) {
                    Text(currentLifeTotal)
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                } else {
                    Text("Lost")
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                }
                Spacer()
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(.white)
        .padding()
        .background(Color(color))
        .overlay(player.loser ? Color.black.opacity(0.25) : nil)
        .cornerRadius(25)
        .padding(5)
        .onAppear {
            self.currentLifeTotal = String(player.currentLifeTotal)
        }
    }
    
    func incrementLifeTotal() -> Void {
        let currentLifeTotal = player.currentLifeTotal
        let nextLifeTotal = currentLifeTotal + 1
        player.currentLifeTotal = nextLifeTotal
        print("increment life total: \(nextLifeTotal)")
        self.currentLifeTotal = String(nextLifeTotal)
    }
    
    func decrementLifeTotal() -> Void {
        let currentLifeTotal = player.currentLifeTotal
        let nextLifeTotal = currentLifeTotal - 1

        if (nextLifeTotal == 0) {
            player.loser = true
            self.loser = true
            numPlayersRemaining = numPlayersRemaining - 1
            print("\(player.name) lost the game")
        }

        player.currentLifeTotal = nextLifeTotal
        print("deccrement life total: \(nextLifeTotal)")
        self.currentLifeTotal = String(nextLifeTotal)
    }
}

struct GameBoard: View {
    @Binding var players: [Participant]
    @Binding var numPlayersRemaining: Int
    
    var colors: [UIColor] = [
        .systemPurple,
        .systemBlue,
        .systemGreen,
        .systemYellow,
        .systemOrange,
        .systemRed,
    ]
    
    var body: some View {
        VStack {
            ForEach(Array(players.enumerated()), id: \.offset) { index, player in
                PlayerTile(player: player, color: colors[index], numPlayersRemaining: $numPlayersRemaining)
            }
        }
        .padding([.leading, .trailing, .bottom])
    }
}

struct WinnerDialog: View {
    var winner: Participant?

    var resetBoard: () -> ()
    var endGame: () -> ()

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
            
            VStack(spacing: 0) {
                Text("\(winner!.name) won the game!")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .padding(.bottom, 25)
                
                HStack {
                    Button(action: { resetBoard() }) {
                        Text("Play Again")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(.white))
                            .frame(maxWidth: 160)
                            .padding()
                            .background(Color(.systemBlue))
                            .cornerRadius(8)
                    }
                    
                    Spacer()
                    
                    Button(action: { endGame() }) {
                        Text("End Game")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(.white))
                            .frame(maxWidth: 160)
                            .padding()
                            .background(Color(.systemRed))
                            .cornerRadius(8)
                    }
                }
            }
            .frame(maxWidth: 400)
            .padding(30)
            .background(Color(.systemGray6))
            .cornerRadius(25)
            .shadow(color: Color.black.opacity(0.25), radius: 20)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView: View {
    @State private var playerCount: Int = 0
    @State private var format: Format? = nil
    @State private var setupStep: Int = 0
    @State private var setupComplete: Bool = false
    @State private var players: [Participant] = []
    @State private var numPlayersRemaining: Int = 0
    @State private var winner: Participant? = nil
    
    @State var timeElapsed: Int = 0

    var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            timeElapsed += 1
        }
    }

    var hours: Int {
      timeElapsed / 3600
    }

    var minutes: Int {
      (timeElapsed % 3600) / 60
    }

    var seconds: Int {
      timeElapsed % 60
    }
    
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
                ZStack {
                    VStack(spacing: 0) {
                        if (self.players.count > 0) {
                            HStack {
                                HStack {
                                    Image(systemName: "person.2.fill")
                                    Text("\(playerCount)")
                                        .foregroundColor(Color(.white))
                                }
                                .padding(.trailing, 5)
                            
                                HStack {
                                    Image(systemName: "menucard.fill")
                                    Text("\(format?.name ?? "")")
                                        .foregroundColor(Color(.white))
                                }
                                .padding(.trailing, 5)
                                
                                HStack {
                                    Image(systemName: "clock.fill")
                                    Text("\(hours < 10 ? "0\(hours)" : "\(hours)"):\(minutes < 10 ? "0\(minutes)" : "\(minutes)"):\(seconds < 10 ? "0\(seconds)" : "\(seconds)")")
                                        .foregroundColor(Color(.white))
                                }
                                
                                Spacer()
                                
                                HStack {
                                    Image(systemName: "gearshape.fill")
                                    Text("Settings")
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .foregroundColor(Color(.systemBlue))
                            .frame(height: 50)
                            .cornerRadius(25)
                            .padding()
                        }
                        
                        GameBoard(players: $players, numPlayersRemaining: $numPlayersRemaining)
                    }
                    
                    if (self.winner != nil) {
                        WinnerDialog(winner: winner, resetBoard: resetBoard, endGame: endGame)
                    }
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

            self.numPlayersRemaining = self.players.count
        }
        .onChange(of: numPlayersRemaining) { newState in
            if (newState == 1 && players.count != 1) {
                let winningPlayer = self.players.filter { $0.loser != true }
                
                if (winningPlayer.count > 0) {
                    self.winner = winningPlayer[0]
                }
            } else if (newState == 0 && players.count == 1) {
                let winningPlayer = self.players[0]
                self.winner = winningPlayer
            }
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
    
    private func resetBoard() {
        let remappedPlayers = players.map { (player: Participant) -> Participant in
            let mutableplayer = player
            mutableplayer.currentLifeTotal = format?.startingLifeTotal ?? 20
            mutableplayer.loser = false
            return mutableplayer
        }

        self.players = []
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
            self.players = remappedPlayers
            self.playerCount = remappedPlayers.count
            self.numPlayersRemaining = remappedPlayers.count
            self.winner = nil
        }
    }
    
    private func endGame() {
        self.setupComplete = false
        self.format = nil
        self.players = []
        self.playerCount = 0
        self.numPlayersRemaining = 0
        self.winner = nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
