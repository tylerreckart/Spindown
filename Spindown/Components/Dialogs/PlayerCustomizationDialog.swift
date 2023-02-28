//
//  PlayerCustomizationDialog.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/27/23.
//

import SwiftUI

struct PlayerCustomizationDialog: View {
    @Binding var isOpen: Bool
    
    @State private var name: String = ""
    @State private var selectedColor: UIColor = UIColor(named: "PrimaryPurple")!
    
    var customize: Bool = false

    var body: some View {
        Dialog(
            content: {
                PlayerCustomizationContext(customize: customize, savePlayer: savePlayer, dismiss: dismiss)
            },
            open: $isOpen
        )
    }
    
    func savePlayer(name: String, color: UIColor) -> Void {}
    
    func dismiss() -> Void {
        withAnimation {
            self.isOpen.toggle()
        }
    }
}

