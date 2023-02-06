//
//  SplashScreen.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/2/23.
//

import SwiftUI

struct SplashScreen: View {
    @Binding var setupStep: Double
    
    @State private var globalOpacity: CGFloat = 0

    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 0) {
                Image("SpindownIcon")
                    .resizable()
                    .frame(maxWidth: 100, maxHeight: 100)
            }
            .padding(.bottom, 35)
            .opacity(globalOpacity)

            HStack {
                Spacer()
                    
                VStack(spacing: 20) {
                    UIButton(text: "Setup Game", symbol: "dice.fill", color: UIColor(named: "PrimaryBlue") ?? .systemGray, action: { self.setupStep += 1 })
                        .frame(maxWidth: 300, maxHeight: 60)
                        .shadow(color: Color.black.opacity(0.1), radius: 10)
                        .opacity(globalOpacity)
                    UIButtonOutlined(text: "Game History", symbol: "text.book.closed", fill: .black, color: .white, action: { self.setupStep += 1 })
                        .frame(maxWidth: 300, maxHeight: 60)
                        .shadow(color: Color.black.opacity(0.1), radius: 10)
                        .opacity(globalOpacity)
                    UIButtonOutlined(text: "Settings", symbol: "gearshape", fill: .black, color: .white, action: { self.setupStep += 1 })
                        .frame(maxWidth: 300, maxHeight: 60)
                        .shadow(color: Color.black.opacity(0.1), radius: 10)
                        .opacity(globalOpacity)
                }
                    
                Spacer()
            }
            Spacer()
        }
        .background(Color(.black))
        .onAppear {
            withAnimation(.easeIn(duration: 1)) {
                self.globalOpacity = 1
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    @State private static var setupStep: Double = 0

    static var previews: some View {
        SplashScreen(setupStep: $setupStep).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
