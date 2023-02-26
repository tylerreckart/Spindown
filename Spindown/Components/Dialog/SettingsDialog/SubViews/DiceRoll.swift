//
//  DiceRoll.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/22/23.
//

import SwiftUI

struct DiceRollView: View {
    @Binding var activeView: ActiveSettingsView

    @State private var rolling: Bool = false
    @State private var result: Int? = nil
    @State private var chosenDie: Int? = nil

    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 0) {
                Image(systemName: "dice")
                    .foregroundColor(Color.white)
                    .font(.system(size: 24, weight: .black))
                    .padding(.trailing, 4)
                Text("Roll Die")
                    .font(.system(size: 24, weight: .black))
                    .foregroundColor(Color.white)
                Spacer()
            }
            
            if (!self.rolling && self.result == nil) {
                VStack(spacing: 20) {
                    HStack(spacing: 20) {
                        UIButton(
                            text: "D20",
                            color: UIColor(named: "AccentGrayDarker")!,
                            action: {
                                rollDice(20)
                            }
                        )
                        UIButton(
                            text: "D12",
                            color: UIColor(named: "AccentGrayDarker")!,
                            action: {
                                rollDice(12)
                            }
                        )
                        UIButton(
                            text: "D10",
                            color: UIColor(named: "AccentGrayDarker")!,
                            action: {
                                rollDice(10)
                            }
                        )
                    }
                    
                    HStack(spacing: 20) {
                        UIButton(
                            text: "D8",
                            color: UIColor(named: "AccentGrayDarker")!,
                            action: {
                                rollDice(8)
                            }
                        )
                        UIButton(
                            text: "D6",
                            color: UIColor(named: "AccentGrayDarker")!,
                            action: {
                                rollDice(6)
                            }
                        )
                        UIButton(
                            text: "D4",
                            color: UIColor(named: "AccentGrayDarker")!,
                            action: {
                                rollDice(4)
                            }
                        )
                    }
                }
            }
            
            if (self.rolling) {
                Spinner()
            }
            
            if (!self.rolling && self.result != nil) {
                HStack {
                    Spacer()
                    Text(String(self.result!))
                        .font(.system(size: 48, weight: .black))
                        .foregroundColor(Color.white)
                    Spacer()
                }
            }
            
            VStack(spacing: 20) {
                if (self.result != nil) {
                    UIButton(
                        text: "Roll Again",
                        symbol: "arrow.counterclockwise",
                        color: UIColor(named: "PrimaryRed")!,
                        action: {
                            rollDice(self.chosenDie!)
                        }
                    )
                    
                    UIButton(
                        text: "Change Die",
                        symbol: "die.face.5",
                        color: UIColor(named: "AccentGrayDarker")!,
                        action: {
                            withAnimation {
                                self.result = nil
                            }
                        }
                    )
                }
                UIButtonOutlined(
                    text: "Go Back",
                    fill: UIColor(named: "DeepGray")!,
                    color: UIColor(named: "AccentGray")!,
                    action: {
                        withAnimation {
                            self.activeView = .home
                        }
                    }
                )
            }
        }
        .onDisappear {
            self.result = nil
        }
        .transition(
            .asymmetric(
                insertion: .push(from: .trailing).combined(with: .opacity),
                removal: .push(from: .leading).combined(with: .opacity)
            )
        )
    }
    
    func rollDice(_ range: Int) -> Void {
        self.chosenDie = range
        
        withAnimation {
            self.rolling = true
            self.result = nil
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    self.result = Int.random(in: 1..<range)
                    self.rolling = false
                }
            }
        }
    }
}
