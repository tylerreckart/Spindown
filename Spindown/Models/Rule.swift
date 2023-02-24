//
//  Rule.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/23/23.
//

import SwiftUI

public struct RulesNavigation: Codable {
    public let previousRule: String?
    public let nextRule: String?
}

class Rule: ObservableObject, Equatable, Identifiable, Hashable {
    var uid: UUID = UUID()
    
    @Published public var ruleNumber: String = ""
    @Published public var examples: [String?]?
    @Published public var ruleText: String = ""
    @Published public var fragment: String?
    @Published public var navigation: RulesNavigation?
    
    static func == (lhs: Rule, rhs: Rule) -> Bool {
        return lhs.uid == rhs.uid
    }
    
    public func hash(into hasher: inout Hasher) -> Void {
        hasher.combine(uid)
    }
}
