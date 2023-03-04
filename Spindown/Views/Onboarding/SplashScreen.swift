//
//  SplashScreen.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/2/23.
//

import SwiftUI
import StoreKit

struct SplashScreen: View {
    var showNextPage: () -> Void
    // Sheet presentation.
    @State private var showSettingsSheet: Bool = false
    @State private var showManageSubscriptions: Bool = false
    @State private var showRulesSheet: Bool = false
    @State private var showHistorySheet: Bool = false
    
    @State private var selectedOffer: Product?
    @State private var hasPurchased: Bool = false
    @State private var errorMessage: String?
    @State private var showErrorAlert: Bool = false

    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .center, spacing: 0) {
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
                    text: "Rule Book",
                    symbol: "book",
                    fill: .black,
                    color: .white,
                    action: {
                        self.showRulesSheet.toggle()
                    }
                )

                UIButtonOutlined(
                    text: "Settings",
                    symbol: "gearshape",
                    fill: .black,
                    color: .white,
                    action: {
                        self.showSettingsSheet.toggle()
                    }
                )
            }
            .frame(maxWidth: 300)
            Spacer()
        }
        .background(Color(.black))
        .transition(
            .asymmetric(
                insertion: .push(from: .trailing),
                removal: .push(from: .trailing))
        )
        .sheet(isPresented: $showSettingsSheet) {
            AppSettingsView(
                dismissModal: {
                    self.showSettingsSheet.toggle()
                },
                showManageSubscriptions: $showManageSubscriptions
            )
        }
        .sheet(isPresented: $showRulesSheet) {
            RulesSheet()
        }
        .manageSubscriptionsSheet(isPresented: $showManageSubscriptions)
    }
}
