//
//  ContentView.swift
//  Spindown
//
//  Created by Tyler Reckart on 1/29/23.
//

import SwiftUI
import StoreKit

enum Page {
    case home
    case lifeTotal
    case players
    case savedPlayers
    case gameBoard
}

func incrementReviewCounter() -> Void {
    // If the app doesn't store the count, this returns 0.
    var count = UserDefaults.standard.integer(forKey: "sessionCount")
    count += 1
    UserDefaults.standard.set(count, forKey: "sessionCount")
    print("player session logged: \(count)")

    // Keep track of the most recent app version that prompts the user for a review.
    let lastVersionPromptedForReview = UserDefaults.standard.string(forKey: "lastReviewedVersion")

    // Get the current bundle version for the app.
    let infoDictionaryKey = kCFBundleVersionKey as String
    guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: infoDictionaryKey) as? String
        else { fatalError("Expected to find a bundle version in the info dictionary.") }
     // Verify the user completes the process several times and doesn’t receive a prompt for this app version.
     if count >= 5 && currentVersion != lastVersionPromptedForReview {
         let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
         
         if (windowScene != nil) {
             SKStoreReviewController.requestReview(in: windowScene!)
             UserDefaults.standard.set(currentVersion, forKey: "lastReviewedVersion")
         }
     }
}

struct ContentView: View {
    @AppStorage("isSubscribed") private var currentEntitlement: Bool = false

    // Initialize store model.
    @StateObject var store: Store = Store()
    
    // Initialize global timer.
    @StateObject var timerModel = GameTimerModel()
    
    // Current board state.
    @State private var playerCount: Int = 0
    @State private var players: [Participant] = []
    @State private var numPlayersRemaining: Int = 0
    @State private var activePlayer: Participant?
    @State private var startingLifeTotal: Int = 0

    // Display.
    @State private var showStartOverlay: Bool = false
    @State private var gameBoardOpacity: CGFloat = 0
    
    // Information Sheets/Subviews.
    @State private var showOnboardingSheet: Bool = false
    
    @State private var orientation: UIDeviceOrientation?
    
    let orientationListener = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
        .makeConnectable()
        .autoconnect()
    
    init() { incrementReviewCounter() }

    var body: some View {
        ZStack {
            if (orientation != nil) {
                GameBoard(
                    store: store,
                    players: $players,
                    numPlayersRemaining: $numPlayersRemaining,
                    activePlayer: $activePlayer,
                    orientation: $orientation,
                    endGame: endGame
                )
                .transition(.opacity)
            }
        }
        .environmentObject(timerModel)
        .onAppear {
            self.setStartingLifeTotal(40)
            self.setPlayerCount(4)
        }
        .onChange(of: store.initialized) { _ in
            Task {
                await checkPlayerEntitlements()
            }
        }
        .onAppear {
            withAnimation {
                self.orientation = UIDevice.current.orientation
            }
        }
        .onReceive(orientationListener) { event in
            let device = event.object.unsafelyUnwrapped.self as! UIDevice
            let current = device.orientation
            
            if (current != .unknown) {
                withAnimation {
                    self.orientation = UIDevice.current.orientation
                }
            }
        }
    }
    
    private func checkPlayerEntitlements() async -> Void {
        if (store.subscriptions.isEmpty) {
            return
        }

        if (store.purchasedSubscriptions.isEmpty) {
            self.currentEntitlement = false
            return
        }

        let sub = store.purchasedSubscriptions[0]
        let status = try? await sub.subscription?.status[0] ?? nil
        
        if (status != nil) {
            print(status!.state.localizedDescription)
            if (status!.state == .expired && (status!.state != .inGracePeriod || status!.state != .inBillingRetryPeriod)) {
                self.currentEntitlement = false
                return
            }
            
            if (status!.state == .revoked) {
                self.currentEntitlement = false
                return
            }
            
            if (currentEntitlement == false) {
                self.currentEntitlement = true
            }
        }
    }

    private func setStartingLifeTotal(_ total: Int) -> Void {
        print("set starting life total: \(total)")
        self.startingLifeTotal = total
    }
    
    private func setPlayerCount(_ numPlayers: Int) {
        print("set player count: \(numPlayers) players")
        self.playerCount = numPlayers
        
        for count in 1..<numPlayers + 1 {
            let player = Participant()
            player.name = "Player \(count)"
            player.lifeTotal = self.startingLifeTotal
            player.color = colors[count - 1]
            player.theme = basicThemes[count - 1]
            self.players.append(player)
        }
        
        chooseAndAdvance()
    }
    
    func chooseAndAdvance() {
        // Select the starting player.
        chooseStartingPlayer()
    
        self.numPlayersRemaining = self.playerCount
    }
    
    private func chooseStartingPlayer() {
        self.activePlayer = self.players.randomElement()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(.easeInOut(duration: 0.4)) {
                self.showStartOverlay = true
            }
        }
    }
    
    private func startGame() {
        withAnimation(.easeInOut(duration: 0.4)) {
            self.showStartOverlay = false
        }
    }
    
    private func resetBoard() {
        for player in self.players {
            player.lifeTotal = self.startingLifeTotal
        }
    }
    
    private func endGame() {
        resetBoard()
    }
}
