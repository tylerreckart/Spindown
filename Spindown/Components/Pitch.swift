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
            Text("Development of this app would not be possible without our subscribers. Show your support and help fund the development of new features by subscribing today.\n\nBoth plans offer a free 2-week trial. You may cancel anytime before the trial ends and you won't be charged.")
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 5)
                .padding(.bottom)
                .padding(.horizontal)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(UIColor(named: "AccentGray")!))

            if !store.subscriptions.isEmpty {
                VStack(alignment: .center) {
                    HStack {
                        Spacer()
                        Text("Choose a Plan")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                        Spacer()
                    }
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
}
