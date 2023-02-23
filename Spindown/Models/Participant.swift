//
//  Participant.swift
//  Spindown
//
//  Created by Tyler Reckart on 1/29/23.
//

import Foundation
import UIKit
import SwiftUI

enum Counter {
    case poison
    case experience
    case energy
    case tickets
}

class Participant: ObservableObject, Equatable, Identifiable, Hashable {
    // Unique Identifier
    var uid: UUID = UUID()
    // Player Name
    var name: String = ""
    // Player's chosen accent color.
    var color: UIColor = UIColor(named: "PrimaryBlue")!
    // Life total given current board state.
    // @Published sends updates to any views watching this value.
    @Published var lifeTotal: Int = 0
    // Counters
    @Published var poison: Int = 0
    @Published var experience: Int = 0
    @Published var energy: Int = 0
    @Published var tickets: Int = 0
    
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
        }
    }
}
