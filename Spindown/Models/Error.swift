//
//  Error.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/14/23.
//

import Foundation

enum ValidationError: LocalizedError {
    case NaN

    var errorDescription: String? {
        switch self {
        case .NaN:
            return "Error"
        }
    }
}
