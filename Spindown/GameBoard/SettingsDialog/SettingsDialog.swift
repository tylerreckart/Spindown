//
//  SettingsDialog.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/2/23.
//

import SwiftUI

struct GameSettingsScreen_Previews: PreviewProvider {
    @State static var activeView: ActiveSettingsView = .layout
    @State static var selectedLayout: BoardLayout = .tandem
    
    static var playerCount: Int = 4
    
    static var previews: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                PlayerSelectorView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                Spacer()
            }
            Spacer()
        }
        .background(.black)
    }
}


struct DiceRollView: View {
    var body: some View {
        Text("Dice Roll")
    }
}

struct TimerView: View {
    var body: some View {
        Text("Timer")
    }
}

struct FormatSelectorView: View {
    var body: some View {
        Text("Format")
    }
}

struct PlayerSelectorView: View {
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Image(systemName: "person.2")
                    .foregroundColor(Color.white)
                    .font(.system(size: 24, weight: .black))
                    .padding(.trailing, 4)
                Text("Change Players")
                    .font(.system(size: 24, weight: .black))
                    .foregroundColor(Color.white)
                Spacer()
            }
            VStack {
                ScrollView {
                    VStack(spacing: 0) {
                        HStack {
                            Image(systemName: "person.circle")
                                .foregroundColor(Color.white)
                            Text("Player 1")
                                .foregroundColor(Color.white)
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color.white)
                        }
                        .font(.system(size: 18, weight: .black))
                        .padding()
                        .background(Color(UIColor(named: "DeepGray") ?? .systemGray5))
 
                        HStack {
                            Image(systemName: "person.circle")
                                .foregroundColor(Color.white)
                            Text("Player 2")
                                .foregroundColor(Color.white)
                            Spacer()
                            Image(systemName: "circle")
                                .foregroundColor(Color(UIColor(named: "AccentGrayDarker") ?? .systemGray))
                        }
                        .font(.system(size: 18, weight: .black))
                        .padding()
                        .background(Color.black)

                        HStack {
                            Image(systemName: "person.circle")
                                .foregroundColor(Color.white)
                            Text("Player 3")
                                .foregroundColor(Color.white)
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color.white)
                        }
                        .font(.system(size: 18, weight: .black))
                        .padding()
                        .background(Color(UIColor(named: "DeepGray") ?? .systemGray5))

                        HStack {
                            Image(systemName: "person.circle")
                                .foregroundColor(Color.white)
                            Text("Player 4")
                                .foregroundColor(Color.white)
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color.white)
                        }
                        .font(.system(size: 18, weight: .black))
                        .padding()
                        .background(Color.black)
                    }
                    .cornerRadius(4)
                }
                .padding(6)
                .background(.black)
                .cornerRadius(8)
            }
            .padding(4)
            .background(Color(UIColor(named: "AccentGrayDarker") ?? .systemGray))
            .cornerRadius(12)
            .frame(maxHeight: 220)
        }
        .frame(width: 300)
        
        VStack {
            UIButtonOutlined(text: "Save", fill: .black, color: UIColor(named: "AccentGray") ?? .systemGray, action: {
                withAnimation {
//                    self.activeView = .home
                }
                
            })
        }
        .frame(maxWidth: 300)
        .padding(.top, 15)
    }
}

extension String {
    func markdownToAttributed() -> AttributedString {
        do {
            return try AttributedString(markdown: self)
        } catch {
            return AttributedString("Error parsing markdown: \(error)")
        }
    }
}

public struct RulesResponse: Codable {
    public let rules: [String:[RulesBody]]
}

public struct RulesNavigation: Codable {
    public let previousRule: String?
    public let nextRule: String?
}

public struct RulesBody: Codable {
    public let ruleNumber: String?
    public let examples: [String?]?
    public let ruleText: String?
    public let fragment: String?
    public let navigation: RulesNavigation?
}

struct RulesSheet: View {
    @State private var isFetchingRules: Bool = false
    @State private var rules: [String:RulesBody] = [:]
    
    let letters = NSCharacterSet.letters

    var body: some View {
        VStack {
            if (isFetchingRules == false) {
                let keys = rules.map{ $0.key }.sorted()
                let values = rules.map { $0.value }

                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("Rulebook")
                                .font(.system(size: 48, weight: .black))
                            Spacer()
                        }

                        ForEach(keys.indices, id: \.self) {index in
                            let target = values.firstIndex { $0.ruleNumber == keys[index] }
                            VStack(alignment: .leading, spacing: 5) {
                                let data = values[target!]
                                HStack(alignment: .top, spacing: 0) {
                                    Text(keys[index])
                                        .font(.system(size: 18, weight: .bold))
                                        .frame(width: 75, alignment: .leading)

                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(data.ruleText ?? "")
                                            .foregroundColor(Color(UIColor(named: "AccentGray") ?? .systemGray5))
                                        if (data.examples != nil) {
                                            VStack(alignment: .leading, spacing: 5) {
                                                Text("Examples")
                                                    .font(.system(size: 18, weight: .bold))
                                                VStack(spacing: 5) {
                                                    ForEach(data.examples!, id: \.self) { example in
                                                        Text(example ?? "")
                                                            .italic()
                                                            .foregroundColor(Color(UIColor(named: "AccentGray") ?? .systemGray5))
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    Spacer()
                                }
                                .padding(.leading, keys[index].rangeOfCharacter(from: letters) != nil ? 75 : 0)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .padding()
                }
            } else {
                Text("Fethcing Rules... Please hold.")
            }
        }
        .foregroundColor(Color.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .onAppear {
            getRules()
        }
    }
    
    func getRules() {
        print("fetching rules")
        let url = URL(string: "https://api.academyruins.com/allrules")!

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            let dRes = try! decoder.decode([String:RulesBody].self, from: data)
            self.rules = dRes
        }

        task.resume()
    }
}

struct GameSettingsHomeView: View {
    var endGame: () -> ()
    var dismissModal: () -> ()
    
    @Binding var activeView: ActiveSettingsView
    
    var playerCount: Int
    
    @State private var showRulesSheet: Bool = false

    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Text("Settings")
                    .font(.system(size: 24, weight: .black))
                    .foregroundColor(Color.white)
                Spacer()
            }
            
            VStack(spacing: 15) {
                HStack(spacing: 15) {
                    UIButtonStacked(text: "Timer", symbol: "stopwatch", color: UIColor(named: "AccentGrayDarker") ?? .systemGray, action: {
                        withAnimation {
                            self.activeView = .timer
                        }
                    })
                    UIButtonStacked(text: "Roll Dice", symbol: "dice", color: UIColor(named: "AccentGrayDarker") ?? .systemGray, action: {
                        withAnimation {
                            self.activeView = .roll
                        }
                    })
                    UIButtonStacked(text: "Rules", symbol: "book", color: UIColor(named: "AccentGrayDarker") ?? .systemGray, action: {
                        self.showRulesSheet.toggle()
                    })
                }
                if (self.playerCount == 2 || self.playerCount == 4 || self.playerCount == 6) {
                    UIButtonOutlined(text: "Change Layout", symbol: "uiwindow.split.2x1", fill: .black, color: UIColor(named: "AccentGray")!, action: {
                        withAnimation {
                            self.activeView = .layout
                        }
                    })
                }
                UIButtonOutlined(text: "Change Format", symbol: "text.book.closed", fill: .black, color: UIColor(named: "AccentGray")!, action: {
                    withAnimation {
                        self.activeView = .format
                    }
                })
                UIButtonOutlined(text: "Change Players", symbol: "person.2", fill: .black, color: UIColor(named: "AccentGray")!, action: {
                    withAnimation {
                        self.activeView = .player
                    }
                })
                UIButton(text: "End Game", symbol: "xmark", color: UIColor(named: "PrimaryRed") ?? .systemGray, action: {
                    dismissModal()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        endGame()
                    }
                })
            }
            .frame(maxWidth: 300)
        }
        .sheet(isPresented: $showRulesSheet, onDismiss: { self.showRulesSheet = false }) {
            RulesSheet()
        }
    }
}

enum ActiveSettingsView {
    case home
    case roll
    case timer
    case layout
    case format
    case player
}

struct GameSettingsDialog: View {
    @Binding var open: Bool
    @Binding var selectedLayout: BoardLayout
    
    var endGame: () -> ()
    
    var playerCount: Int

    @State private var overlayOpacity: CGFloat = 0
    @State private var dialogOpacity: CGFloat = 0
    @State private var dialogOffset: CGFloat = 0.75
    
    @State private var activeView: ActiveSettingsView = .home
    
    var body: some View {
        ZStack {
            Color.black.opacity(overlayOpacity)
                .onTapGesture {
                    dismissModal()
                }
            
            VStack {
                switch (activeView) {
                    case .home:
                        GameSettingsHomeView(endGame: endGame, dismissModal: dismissModal, activeView: $activeView, playerCount: playerCount)
                    case .roll:
                        DiceRollView()
                    case .timer:
                        TimerView()
                    case .layout:
                        LayoutSelectorView(activeView: $activeView, selectedLayout: $selectedLayout, playerCount: playerCount)
                    case .format:
                        FormatSelectorView()
                    case .player:
                        PlayerSelectorView()
                }
            }
            .frame(maxWidth: 300)
            .padding(30)
            .background(
                Color(.black)
                    .overlay(LinearGradient(colors: [.white.opacity(0.05), .clear], startPoint: .top, endPoint: .bottom))
            )
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 15)
            .opacity(dialogOpacity)
            .scaleEffect(dialogOffset)
            .onAppear {
                withAnimation {
                    self.overlayOpacity = 0.5
                    self.dialogOpacity = 1
                    self.dialogOffset = 1.1
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation {
                            self.dialogOffset = 1
                        }
                    }
                }
            }
        }
    }
    
    func dismissModal() {
        withAnimation {
            self.overlayOpacity = 0
            self.dialogOpacity = 0
            self.dialogOffset = 0.75
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            open.toggle()
        }
    }
}
