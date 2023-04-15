//
//  SpindownApp.swift
//  Spindown
//
//  Created by Tyler Reckart on 1/29/23.
//
import SwiftUI

@main
struct SpindownApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
                .background(.black)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
