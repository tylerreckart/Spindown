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
    var selectedPlayer: Participant? = nil

    var body: some View {
        Dialog(
            content: {
                PlayerCustomizationContext(
                    customize: customize,
                    savePlayer: save,
                    dismiss: dismiss,
                    delete: delete,
                    selectedPlayer: selectedPlayer
                )
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
    
    func delete(_ player: Participant) {
        let target = Player(context: managedObjectContext)
        target.uid = player.uid
        
        managedObjectContext.delete(target)
        
        withAnimation {
            self.isOpen.toggle()
        }
    }
       
    func saveContext() {
       do {
           try managedObjectContext.save()

           withAnimation {
               self.isOpen.toggle()
           }
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

