//
//  SplashScreen.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/2/23.
//

import SwiftUI
import StoreKit

struct SplashScreen: View {
    @StateObject var store: Store = Store()

    var showNextPage: () -> Void
    // Sheet presentation.
    @State private var showOnboardingSheet: Bool = false
    @State private var showSettingsSheet: Bool = false
    @State private var showManageSubscriptions: Bool = false
    
    @State private var selectedOffer: Product?
    @State private var hasPurchased: Bool = false
    @State private var errorMessage: String?
    @State private var showErrorAlert: Bool = false

    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                VStack(spacing: 0) {
                    Image("SpindownIcon")
                        .resizable()
                        .frame(maxWidth: 100, maxHeight: 100)
                }
                .padding(.bottom, 35)
                
                VStack(spacing: 20) {
                    UIButton(
                        text: "Setup Game",
                        symbol: "dice.fill",
                        color: UIColor(named: "PrimaryBlue")!,
                        action: { showNextPage() }
                    )

                    UIButtonOutlined(
                        text: "Settings",
                        symbol: "gearshape",
                        fill: .black,
                        color: .white,
                        action: {
                            self.showSettingsSheet.toggle()
                        })
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
        .onChange(of: store.subscriptions) { newState in
            // Set a 1/4 second delay to allow for the store to populate subscriptions
            // and purchases async. This prevents the sheet/dialog from showing to
            // existing subscribers.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                if (newState.count > 0 && store.purchasedSubscriptions.isEmpty) {
                    self.showOnboardingSheet.toggle()
                }
            }
        }
        .onChange(of: store.purchasedSubscriptions) { newState in
            // Ensure that the onboarding dialog/sheet does not show to existing subscribers.
            if (!newState.isEmpty) {
                self.showOnboardingSheet = false
            }
        }
        .sheet(isPresented: $showSettingsSheet) {
            AppSettingsView(
                dismissModal: {
                    self.showSettingsSheet.toggle()
                },
                showManageSubscriptions: $showManageSubscriptions
            )
        }
        .sheet(isPresented: $showOnboardingSheet) {
            SubscriptionView(store: store)
        }
        .manageSubscriptionsSheet(isPresented: $showManageSubscriptions)
    }

    func buy() async {
        do {
            if try await store.purchase(selectedOffer!) != nil {
                hasPurchased = true
            }
        } catch StoreError.failedVerification {
            errorMessage = "Your purchase could not be verified by the App Store."
            showErrorAlert = true
        } catch {
            print("Failed purchase: \(error)")
        }
    }
}
