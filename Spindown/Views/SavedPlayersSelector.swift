//
//  SavedPlayersSelector.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/6/23.
//

import SwiftUI

struct PlayerCustomizationContext: View {
    @State private var name: String = ""
    @State private var selectedColor: UIColor = UIColor(named: "PrimaryPurple")!
    
    var customize: Bool = false

    var savePlayer: (_ name: String, _ color: UIColor) -> Void
    var dismiss: () -> Void
    
    var selectedPlayer: Participant? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 0) {
                Image(systemName: "person")
                    .foregroundColor(Color.white)
                    .font(.system(size: 24, weight: .black))
                    .padding(.trailing, 4)
                Text(self.customize ? "Edit Player" : "Add New Player")
                    .font(.system(size: 24, weight: .black))
                    .foregroundColor(Color.white)
                Spacer()
            }

            StyledTextField(placeholderText: "Player Name...",  text: $name, field: .name, focusOnAppear: true)
            
            Text("Select A Color")
                .font(.system(size: 16))
                .foregroundColor(Color(UIColor(named: "AccentGray")!))
            
            HStack {
                ForEach(colors, id: \.self) { color in
                    HStack {
                        Button(action: {
                            withAnimation {
                                self.selectedColor = color
                            }
                        }) {
                            Circle()
                                .fill(Color(color))
                                .frame(width: 30, height: 30)
                                .padding(4)
                                .background(self.selectedColor == color ? .white : .clear)
                                .cornerRadius(.infinity)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            
            HStack(spacing: 20) {
                UIButton(
                    text: "Save Player",
                    color: (self.name.count != 0 ? UIColor(named: "PrimaryRed")! : UIColor(named: "AccentGrayDarker"))!,
                    action: {
                        savePlayer(self.name, self.selectedColor)
                    }
                )
                .opacity(self.name.count != 0 ? 1 : 0.5)
                
                UIButtonOutlined(
                    text: "Cancel",
                    fill: UIColor(named: "DeepGray")!,
                    color: UIColor(named: "AccentGray")!,
                    action: dismiss
                )
                
            }
        }
        .onAppear {
            if (self.customize && self.selectedPlayer != nil) {
                self.name = self.selectedPlayer!.name
                self.selectedColor = self.selectedPlayer!.color
            }
        }
        .transition(
            .asymmetric(
                insertion: .push(from: .trailing).combined(with: .opacity),
                removal: .push(from: .leading).combined(with: .opacity)
            )
        )
    }
}

struct PlayerCustomizationDialog: View {
    @Binding var isOpen: Bool
    
    @State private var name: String = ""
    @State private var selectedColor: UIColor = UIColor(named: "PrimaryPurple")!
    
    var customize: Bool = false

    var body: some View {
        Dialog(
            content: {
                PlayerCustomizationContext(customize: customize, savePlayer: savePlayer, dismiss: dismiss)
            },
            open: $isOpen
        )
    }
    
    func savePlayer(name: String, color: UIColor) -> Void {}
    
    func dismiss() -> Void {
        withAnimation {
            self.isOpen.toggle()
        }
    }
}

struct SavedPlayersSelector: View {
    @Binding var currentPage: Page

    var setPlayers: () -> ()
    
    @State private var players: [Participant] = []
    @State private var showCustomizationDialog: Bool = false

    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 0) {
                HStack {
                    Button(action: {
                        withAnimation {
                            self.currentPage = .players
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
                    Text("Saved Players")
                        .font(.system(size: UIDevice.current.userInterfaceIdiom == .pad ? 64 : 48, weight: .black))
                        .foregroundColor(.white)
                        .padding(.bottom, 5)
                    Text("Select or add saved players.")
                        .font(.system(size: UIDevice.current.userInterfaceIdiom == .pad ? 20 : 16))
                        .foregroundColor(Color(.systemGray))
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                }
                .padding(.bottom, 20)
                
                VStack(spacing: 20) {
                    PlayerList(players: $players)
                    
                    UIButtonOutlined(
                        text: "Add Player",
                        symbol: "plus",
                        fill: .black,
                        color: UIColor(named: "AccentGray")!,
                        action: {
                            withAnimation {
                                self.showCustomizationDialog.toggle()
                            }
                        }
                    )
                    UIButton(
                        text: "Start Game",
                        color: players.count > 0 ? UIColor(named: "PrimaryBlue")! : UIColor(named: "AccentGrayDarker")!,
                        action: {}
                    )
                    .opacity(players.count > 0 ? 1 : 0.5)
                    .disabled(players.count == 0)
                }
                .frame(maxWidth: 400)
                
                
                Spacer()
            }
            .foregroundColor(Color.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .padding(.horizontal)
            
            PlayerCustomizationDialog(isOpen: $showCustomizationDialog)
        }
    }
}

struct SavedPlayersSelector_Previews: PreviewProvider {
    @State private static var setupStep: Double = 0
    @State private static var currentPage: Page = .savedPlayers
    
    static func setPlayers() {}

    static var previews: some View {
        SavedPlayersSelector(
            currentPage: $currentPage,
            setPlayers: setPlayers
        ).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
