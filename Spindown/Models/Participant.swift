//
//  Participant.swift
//  Spindown
//
//  Created by Tyler Reckart on 1/29/23.
//

import Foundation
import UIKit
import SwiftUI

enum ThemeType {
    case basic
}

struct Theme: Identifiable {
    var id: UUID = UUID()
    
    var type: ThemeType
    var background: String
    
    var tileBackground: some View {
        return Image(background)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
            .clipped()
    }
    
    var backgroundKey: String
}

let basicThemes = [
    Theme(type: .basic, background: "Forest", backgroundKey: "Forest"),
    Theme(type: .basic, background: "Island", backgroundKey: "Island"),
    Theme(type: .basic, background: "Mountain", backgroundKey: "Mountain"),
    Theme(type: .basic, background: "Plains", backgroundKey: "Plains"),
    Theme(type: .basic, background: "Swamp", backgroundKey: "Swamp")
]

class Participant: ObservableObject, Equatable, Identifiable, Hashable {
    // Unique Identifier
    var uid: UUID = UUID()
    // Player Name
    @Published var name: String = ""
    // Player's chosen accent color.
    @Published var color: UIColor = UIColor(named: "PrimaryBlue")!
    // Life total given current board state.
    // @Published sends updates to any views watching this value.
    @Published var lifeTotal: Int = 0
    // Counters
    @Published var poison: Int = 0
    @Published var experience: Int = 0
    @Published var energy: Int = 0
    @Published var tickets: Int = 0
    // Display theme.
    var theme: Theme? = nil
    
    static func == (lhs: Participant, rhs: Participant) -> Bool {
        return lhs.uid == rhs.uid
    }
    
    public func hash(into hasher: inout Hasher) -> Void {
        hasher.combine(uid)
    }
    
    public func incrementLifeTotal() -> Void {
        self.lifeTotal = self.lifeTotal + 1
    }
    
    public func decrementLifeTotal() -> Void {
        self.lifeTotal = self.lifeTotal - 1
    }
    
    public func setLifeTotal(_ newLifeTotal: Int) {
        self.lifeTotal = newLifeTotal
    }
    
    public func addCounter(_ counter: Counter) {
        switch (counter) {
            case .poison:
                self.poison += 1
            case .energy:
                self.energy += 1
            case .experience:
                self.experience += 1
            case .tickets:
                self.tickets += 1
            case .lifeTotal:
                return
        }
    }
    
    public func removeCounter(_ counter: Counter) {
        switch (counter) {
            case .poison:
                self.poison -= 1
            case .energy:
                self.energy -= 1
            case .experience:
                self.experience -= 1
            case .tickets:
                self.tickets -= 1
            case .lifeTotal:
                return
        }
    }
}
