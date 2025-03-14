//
//  SubscriptionTile.swift
//  Spindown
//
//  Created by Tyler Reckart on 3/8/23.
//
import SwiftUI
import StoreKit

struct SubscriptionTile: View {
    var sub: Product?

    @Binding var selectedOffer: Product?

    var body: some View {
        Button(action: {
            selectedOffer = sub
        }) {
            VStack {
                VStack(spacing: 0) {
                    Text("Spindown Plus")
                        .font(.system(size: 12, weight: .bold))
                        .padding(.top, 6)
                    VStack(spacing: 2) {
                        Text("\(sub?.displayPrice ?? "$0.99")")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.bottom, 5)

                        Text("Yearly subscription\nCancel anytime")
                            .font(.caption)
                            .foregroundColor(Color(UIColor(named: "AccentGray")!))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(UIColor(named: "DeepGray")!))
                    .cornerRadius(6)
                    .padding(4)
                    .foregroundColor(.white)
                }
            }
            .frame(width: 140, height: 120)
            .foregroundColor(selectedOffer == sub ? .black : .white)
            .background(selectedOffer == sub ? .white : Color(UIColor(named: "AccentGrayDarker")!))
            .cornerRadius(8)
        }
        .onAppear {
            if selectedOffer == nil && sub?.id == "com.spindown.plus.yearly" {
                selectedOffer = sub
            }
        }
    }
}
