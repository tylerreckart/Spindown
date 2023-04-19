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
    @Published var monarch: Bool = false
    @Published var poison: Int = 0
    @Published var experience: Int = 0
    @Published var energy: Int = 0
    @Published var tickets: Int = 0
    @Published var tax: Int = 0
    @Published var activeCounters: [Counter] = []
    // Floating Mana.
    @Published var red: Int = 0
    @Published var blue: Int = 0
    @Published var green: Int = 0
    @Published var white: Int = 0
    @Published var black: Int = 0
    @Published var colorless: Int = 0
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
    
    public func toggleMonarchy() {
        self.monarch.toggle()
    }
    
    public func addCounter(_ counter: Counter) {
        switch (counter) {
            case .tax:
                self.tax += 2
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
            case .red:
                self.red += 1
            case .blue:
                self.blue += 1
            case .green:
                self.green += 1
            case .white:
                self.white += 1
            case .black:
                self.black += 1
            case .colorless:
                self.colorless += 1
        }
        
        trackActiveCounters()
    }
    
    public func removeCounter(_ counter: Counter) {
        switch (counter) {
            case .tax:
                if (self.tax - 2 >= 0) {
                    self.tax -= 2
                } else {
                    self.tax = 0
                }
            case .poison:
                if (self.poison - 1 >= 0) {
                    self.poison -= 1
                } else {
                    self.poison = 0
                }
            case .energy:
                if (self.energy - 1 >= 0) {
                    self.energy -= 1
                } else {
                    self.energy = 0
                }
            case .experience:
                if (self.experience - 1 >= 0) {
                    self.experience -= 1
                } else {
                    self.experience = 0
                }
            case .tickets:
                if (self.tickets - 1 >= 0) {
                    self.tickets -= 1
                } else {
                    self.tickets = 0
                }
            case .lifeTotal:
                return
            case .red:
                if (self.red - 1 >= 0) {
                    self.red -= 1
                } else {
                    self.red = 0
                }
            case .green:
                if (self.green - 1 >= 0) {
                    self.green -= 1
                } else {
                    self.green = 0
                }
            case .blue:
                if (self.blue - 1 >= 0) {
                    self.blue -= 1
                } else {
                    self.blue = 0
                }
            case .white:
                if (self.white - 1 >= 0) {
                    self.white -= 1
                } else {
                    self.white = 0
                }
            case .black:
                if (self.black - 1 >= 0) {
                    self.black -= 1
                } else {
                    self.black = 0
                }
            case .colorless:
                if (self.colorless - 1 >= 0) {
                    self.colorless -= 1
                } else {
                    self.colorless = 0
                }
        }
        
        trackActiveCounters()
    }
    
    private func trackActiveCounters() -> Void {
        // Commander Tax
        if (self.tax > 0) {
            let index = self.activeCounters.firstIndex(of: .tax)
            
            if (index == nil) {
                self.activeCounters.append(.tax)
            }
        } else if (self.tax == 0) {
            let index = self.activeCounters.firstIndex(of: .tax)
            
            if (index != nil) {
                self.activeCounters.remove(at: index!)
            }
        }
        
        // Poison
        if (self.poison > 0) {
            let index = self.activeCounters.firstIndex(of: .poison)
            
            if (index == nil) {
                self.activeCounters.append(.poison)
            }
        } else if (self.poison == 0) {
            let index = self.activeCounters.firstIndex(of: .poison)
            
            if (index != nil) {
                self.activeCounters.remove(at: index!)
            }
        }
        
        // Energy
        if (self.energy > 0) {
            let index = self.activeCounters.firstIndex(of: .energy)
            
            if (index == nil) {
                self.activeCounters.append(.energy)
            }
        } else if (self.energy == 0) {
            let index = self.activeCounters.firstIndex(of: .energy)
            
            if (index != nil) {
                self.activeCounters.remove(at: index!)
            }
        }
        
        // Experience
        if (self.experience > 0) {
            let index = self.activeCounters.firstIndex(of: .experience)
            
            if (index == nil) {
                self.activeCounters.append(.experience)
            }
        } else if (self.experience == 0) {
            let index = self.activeCounters.firstIndex(of: .experience)
            
            if (index != nil) {
                self.activeCounters.remove(at: index!)
            }
        }
        
        // Tickets
        if (self.tickets > 0) {
            let index = self.activeCounters.firstIndex(of: .tickets)
            
            if (index == nil) {
                self.activeCounters.append(.tickets)
            }
        } else if (self.tickets == 0) {
            let index = self.activeCounters.firstIndex(of: .tickets)
            
            if (index != nil) {
                self.activeCounters.remove(at: index!)
            }
        }
        
        // Red
        if (self.red > 0) {
            let index = self.activeCounters.firstIndex(of: .red)
            
            if (index == nil) {
                self.activeCounters.append(.red)
            }
        } else if (self.red == 0) {
            let index = self.activeCounters.firstIndex(of: .red)
            
            if (index != nil) {
                self.activeCounters.remove(at: index!)
            }
        }
        
        // Green
        if (self.green > 0) {
            let index = self.activeCounters.firstIndex(of: .green)
            
            if (index == nil) {
                self.activeCounters.append(.green)
            }
        } else if (self.green == 0) {
            let index = self.activeCounters.firstIndex(of: .green)
            
            if (index != nil) {
                self.activeCounters.remove(at: index!)
            }
        }
        
        // Blue
        if (self.blue > 0) {
            let index = self.activeCounters.firstIndex(of: .blue)
            
            if (index == nil) {
                self.activeCounters.append(.blue)
            }
        } else if (self.blue == 0) {
            let index = self.activeCounters.firstIndex(of: .blue)
            
            if (index != nil) {
                self.activeCounters.remove(at: index!)
            }
        }
        
        // White
        if (self.white > 0) {
            let index = self.activeCounters.firstIndex(of: .white)
            
            if (index == nil) {
                self.activeCounters.append(.white)
            }
        } else if (self.white == 0) {
            let index = self.activeCounters.firstIndex(of: .white)
            
            if (index != nil) {
                self.activeCounters.remove(at: index!)
            }
        }
        
        // Black
        if (self.black > 0) {
            let index = self.activeCounters.firstIndex(of: .black)
            
            if (index == nil) {
                self.activeCounters.append(.black)
            }
        } else if (self.black == 0) {
            let index = self.activeCounters.firstIndex(of: .black)
            
            if (index != nil) {
                self.activeCounters.remove(at: index!)
            }
        }
        
        // Colorless
        if (self.colorless > 0) {
            let index = self.activeCounters.firstIndex(of: .colorless)
            
            if (index == nil) {
                self.activeCounters.append(.colorless)
            }
        } else if (self.colorless == 0) {
            let index = self.activeCounters.firstIndex(of: .colorless)
            
            if (index != nil) {
                self.activeCounters.remove(at: index!)
            }
        }
    }
    
}
