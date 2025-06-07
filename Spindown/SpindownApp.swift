//
//  SpindownApp.swift
//  Spindown
//
//  Created by Tyler Reckart on 1/29/23.
//
import SwiftUI
import HappyPath

@main
struct SpindownApp: App {
    let persistenceController = PersistenceController.shared
    let reviewManager = ReviewManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .background(.black)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear {
                    ReviewManager.shared.incrementAppLaunchCount()
                }
        }
    }
}
