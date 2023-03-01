//
//  PlayerCustomizationDialog.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/27/23.
//

import SwiftUI

struct PlayerCustomizationDialog: View {
    @Environment(\.managedObjectContext) var managedObjectContext

    @Binding var isOpen: Bool

    var customize: Bool = false

    var body: some View {
        Dialog(
            content: {
                PlayerCustomizationContext(customize: customize, savePlayer: save, dismiss: dismiss)
            },
            open: $isOpen
        )
    }
    
    func save(name: String, color: UIColor) -> Void {
        let target = Player(context: managedObjectContext)
        target.uid = UUID()
        target.name = name
        target.color = NSKeyedArchiver.archivedData(withRootObject: color)

        saveContext()
    }
       
    func saveContext() {
       do {
           try managedObjectContext.save()
           self.isOpen.toggle()
       } catch {
           print("Error saving managed object context: \(error)")
       }
    }
    
    func dismiss() -> Void {
        withAnimation {
            self.isOpen.toggle()
        }
    }
}

