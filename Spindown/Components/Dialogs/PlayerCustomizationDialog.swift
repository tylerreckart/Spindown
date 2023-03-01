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
    @Binding var selectedPlayer: Participant?
    var savedPlayerList: FetchedResults<Player>

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
    
    func save(uid: UUID, name: String, color: UIColor) -> Void {
        let targetIndex = savedPlayerList.firstIndex(where: { $0.uid == uid })
        
        if (targetIndex != nil) {
            let target = savedPlayerList[targetIndex!]
            target.setValue(name, forKey: "name")
            target.setValue(NSKeyedArchiver.archivedData(withRootObject: color), forKey: "color")
        } else {
            let target = Player(context: managedObjectContext)
            target.uid = uid
            target.name = name
            target.color = NSKeyedArchiver.archivedData(withRootObject: color)
        }

        saveContext()
    }
    
    func delete(_ player: Participant) {
        let targetIndex = savedPlayerList.firstIndex(where: { $0.uid == player.uid })
        
        managedObjectContext.delete(savedPlayerList[targetIndex!])
        
        saveContext()
    }
       
    func saveContext() {
        self.selectedPlayer = nil

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

