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
    
    @State private var showOnboardingDialog: Bool = false
    @State private var showOnboardingSheet: Bool = false
    @State private var showSettingsDialog: Bool = false
    @State private var showSettingsSheet: Bool = false
    @State private var showManageSubscriptions: Bool = false
    
    @State private var selectedOffer: Product?
    @State private var hasPurchased: Bool = false
    @State private var errorMessage: String?
    @State private var showErrorAlert: Bool = false

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
                            if UIDevice.current.userInterfaceIdiom == .pad {
                                self.showSettingsDialog.toggle()
                            } else {
                                self.showSettingsSheet.toggle()
                            }
                        })
                }
                .frame(maxWidth: 300)
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
            // Set a 1/4 second delay to allow for the store to populate subscriptions
            // and purchases async. This prevents the sheet/dialog from showing to
            // existing subscribers.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                if (newState.count > 0 && store.purchasedSubscriptions.isEmpty) {
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        self.showOnboardingDialog.toggle()
                    } else {
                        self.showOnboardingSheet.toggle()
                    }
                }
            }
        }
        .onChange(of: store.purchasedSubscriptions) { newState in
            // Ensure that the onboarding dialog/sheet does not show to existing subscribers.
            if (!newState.isEmpty) {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    self.showOnboardingDialog = false
                } else {
                    self.showOnboardingSheet = false
                }
            }
        }
        .sheet(isPresented: $showSettingsSheet) {
            NavigationStack {
                AppSettingsView(dismissModal: dismissModal, showManageSubscriptions: $showManageSubscriptions)
            }
        }
        .sheet(isPresented: $showOnboardingSheet) {
            SubscriptionView(
                store: store,
                selectedOffer: $selectedOffer,
                hasPurchased: $hasPurchased,
                showManageSubscriptions: $showManageSubscriptions,
                buy: buy
            )
        }
        .manageSubscriptionsSheet(isPresented: $showManageSubscriptions)
    }
    
    func dismissModal() {
        self.showSettingsSheet.toggle()
    }
    
    func buy() async {
        do {
            print(selectedOffer as Any)
            print(store.subscriptions)
            if try await store.purchase(selectedOffer!) != nil {
                withAnimation {
                    hasPurchased = true
                }
            }
        } catch StoreError.failedVerification {
            errorMessage = "Your purchase could not be verified by the App Store."
            showErrorAlert = true
        } catch {
            print("Failed purchase: \(error)")
        }
    }
}
