//
//  Format.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/2/23.
//

import Foundation

struct Format: Hashable {
    public static func == (lhs: Format, rhs: Format) -> Bool {
        return lhs.name == rhs.name
    }

    var name: String
    var startingLifeTotal: Int16
}
