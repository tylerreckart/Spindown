//
//  Participant.swift
//  Spindown
//
//  Created by Tyler Reckart on 1/29/23.
//

import Foundation
import UIKit

class Participant: ObservableObject, Equatable, Identifiable, Hashable {
    var uid: UUID = UUID()
    var name: String = ""
    var currentLifeTotal: Int = 0
    var startingLifeTotal: Int = 0
    var color: UIColor = UIColor(named: "PrimaryBlue") ?? .systemGray
    var loser: Bool = false
    
    static func == (lhs: Participant, rhs: Participant) -> Bool {
        return lhs.uid == rhs.uid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
}
