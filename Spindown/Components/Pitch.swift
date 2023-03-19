//
//  Pitch.swift
//  Spindown
//
//  Created by Tyler Reckart on 3/9/23.
//

import SwiftUI
import StoreKit

struct Pitch: View {
    var store: Store

    @Binding var selectedOffer: Product?

    var body: some View {
        VStack(alignment: .center) {
            Text("Development of this app would not be possible without our subscribers. Gain access to additional features like **Saved Players**, **Player Counters**, **Game Timers** and more with a Spindown plus subscription.")
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 5)
                .padding(.bottom)
                .padding(.horizontal)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(UIColor(named: "AccentGray")!))

            if !store.subscriptions.isEmpty {
                HStack(spacing: 20) {
                    ForEach(store.subscriptions) { sub in
                        SubscriptionTile(sub: sub, selectedOffer: $selectedOffer)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
        }
    }
}
