//
//  SplashScreen.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/2/23.
//

import SwiftUI

struct SplashScreen: View {
    @StateObject var store: Store = Store()

    var showNextPage: () -> Void
    
    @State private var showOnboardingDialog: Bool = false
    @State private var showSettingsDialog: Bool = false

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                VStack(spacing: 0) {
                    Image("SpindownIcon")
                        .resizable()
                        .frame(maxWidth: 100, maxHeight: 100)
                }
                .padding(.bottom, 35)
                
                HStack {
                    Spacer()
                    
                    VStack(spacing: 20) {
                        UIButton(text: "Setup Game", symbol: "dice.fill", color: UIColor(named: "PrimaryBlue") ?? .systemGray, action: { showNextPage() })
                            .shadow(color: Color.black.opacity(0.1), radius: 10)
                        UIButtonOutlined(text: "Settings", symbol: "gearshape", fill: .black, color: .white, action: { self.showSettingsDialog.toggle() })
                            .shadow(color: Color.black.opacity(0.1), radius: 10)
                    }
                    .frame(maxWidth: 300)
                    
                    Spacer()
                }
                Spacer()
            }
            .background(Color(.black))
            .transition(
                .asymmetric(
                    insertion: .opacity,
                    removal: .push(from: .trailing))
            )
            
            if (showOnboardingDialog) {
                VStack {
                    Spacer()
                    SubscriptionDialog(store: store)
                    Spacer()
                }
            }
            
            if (showSettingsDialog) {
                VStack {
                    Spacer()
                    AppSettingsDialog(store: store, open: $showSettingsDialog)
                    Spacer()
                }
            }
        }
        .onChange(of: store.subscriptions) { newState in
            if (newState.count > 0 && store.purchasedSubscriptions.isEmpty) {
                print("render onboarding dialog")
                self.showOnboardingDialog = true
            }
        }
        .onChange(of: store.purchasedSubscriptions) { newState in
            if (!newState.isEmpty) {
                self.showOnboardingDialog = false
            }
        }
    }
}
