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
                            .frame(maxWidth: 300, maxHeight: 60)
                            .shadow(color: Color.black.opacity(0.1), radius: 10)
                        UIButtonOutlined(text: "Settings", symbol: "gearshape", fill: .black, color: .white, action: {})
                            .frame(maxWidth: 300, maxHeight: 60)
                            .shadow(color: Color.black.opacity(0.1), radius: 10)
                    }
                    
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
            
            VStack {
                Spacer()
                SubscriptionDialog(store: store)
                Spacer()
            }
        }
    }
}
