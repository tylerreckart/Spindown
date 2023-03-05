//
//  StartingLifeTotalSelector.swift
//  Spindown
//
//  Created by Tyler Reckart on 1/29/23.
//

import SwiftUI

struct StartingLifeTotalSelector: View {
    @Binding var currentPage: Page

    var setStartingLifeTotal: (Int) -> ()
    
    @State private var reverseAnimation: Bool = false
    
    var body: some View {
        VStack {
            OnboardingBackButton(action: {
                self.reverseAnimation.toggle()
                withAnimation {
                    self.currentPage = .home
                }
            })

            VStack {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    Text("Starting Life")
                        .font(.system(size: 64, weight: .black))
                        .foregroundColor(.white)
                        .padding(.bottom, 5)
                    Text("Select your starting life total.")
                        .font(.system(size: 20))
                        .foregroundColor(Color(.systemGray))
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                } else {
                    Text("Starting Life")
                        .font(.system(size: 48, weight: .black))
                        .foregroundColor(.white)
                        .padding(.bottom, 5)
                    Text("Select your starting life total.")
                        .font(.system(size: 16))
                        .foregroundColor(Color(.systemGray))
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                }
            }
            .padding(.bottom)

            VStack(spacing: 20) {
                HStack(spacing: 20) {
                    UIButtonTile(text: "20", symbol: nil, color: UIColor(named: "AccentGrayDarker")!, action: {
                        setStartingLifeTotal(20)
                    })
                    UIButtonTile(text: "30", symbol: nil, color: UIColor(named: "AccentGrayDarker")!, action: {
                        setStartingLifeTotal(30)
                    })
                    UIButtonTile(text: "40", symbol: nil, color: UIColor(named: "AccentGrayDarker")!, action: {
                        setStartingLifeTotal(40)
                    })
                }
                HStack(spacing: 20) {
                    UIButtonTile(text: "50", symbol: nil, color: UIColor(named: "AccentGrayDarker")!, action: {
                        setStartingLifeTotal(50)
                    })
                    UIButtonTile(text: "60", symbol: nil, color: UIColor(named: "AccentGrayDarker")!, action: {
                        setStartingLifeTotal(60)
                    })
                    UIButtonTile(text: "100", symbol: nil, color: UIColor(named: "AccentGrayDarker")!, action: {
                        setStartingLifeTotal(100)
                    })
                }
            }
            
            Spacer()
        }
        .transition(
            .asymmetric(
                insertion: .push(from: self.reverseAnimation != true ? .trailing : .leading),
                removal: .push(from: .trailing)
            )
        )
    }
}

