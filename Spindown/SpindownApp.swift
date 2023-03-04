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

    @StateObject var store: Store = Store()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .background(.black)
                .environmentObject(store)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
