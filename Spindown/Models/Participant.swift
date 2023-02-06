//
//  Participant.swift
//  Spindown
//
//  Created by Tyler Reckart on 1/29/23.
//

import Foundation
import UIKit

class Participant: ObservableObject, Equatable, Identifiable, Hashable {
    static func == (lhs: Participant, rhs: Participant) -> Bool {
        return lhs.uid == rhs.uid
    }
    
    public func hash(into hasher: inout Hasher) -> Void {
        hasher.combine(uid)
    }

    // Unique Identifier
    var uid: UUID = UUID()
    // Player Name
    var name: String = ""
    // Life total given current board state.
    // @Published sends updates to any views watching this value.
    @Published var currentLifeTotal: Int = 0
    // Life total at start of game.
    var startingLifeTotal: Int = 0
    // Player's chosen accent color.
    var color: UIColor = UIColor(named: "PrimaryBlue")!
    // Has this player lost the game?
    var loser: Bool = false
    
    public func incrementLifeTotal() -> Void {
        self.currentLifeTotal = self.currentLifeTotal + 1
    }
    
    public func decrementLifeTotal() -> Void {
        self.currentLifeTotal = self.currentLifeTotal - 1
    }
    
    public func setLifeTotal(_ newLifeTotal: Int) {
        self.currentLifeTotal = newLifeTotal
    }
}
