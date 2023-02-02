//
//  SplashScreen.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/2/23.
//

import SwiftUI

struct SplashScreen: View {
    @Binding var setupStep: Int
    
    @State private var globalOpacity: CGFloat = 0
    
    @State private var firstOffset: CGFloat = 100
    @State private var firstButtonOpacity: CGFloat = 0
    @State private var secondOffset: CGFloat = 100
    @State private var secondButtonOpacity: CGFloat = 0
    @State private var thirdOffset: CGFloat = 100
    @State private var thirdButtonOpacity: CGFloat = 0

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
                        .opacity(firstButtonOpacity)
                    UIButtonOutlined(text: "Game History", symbol: "text.book.closed", fill: .black, color: .white, action: { self.setupStep += 1 })
                        .frame(maxWidth: 300, maxHeight: 60)
                        .shadow(color: Color.black.opacity(0.1), radius: 10)
                        .opacity(secondButtonOpacity)
                    UIButtonOutlined(text: "Settings", symbol: "gearshape", fill: .black, color: .white, action: { self.setupStep += 1 })
                        .frame(maxWidth: 300, maxHeight: 60)
                        .shadow(color: Color.black.opacity(0.1), radius: 10)
                        .opacity(thirdButtonOpacity)
                }
                    
                Spacer()
            }
            Spacer()
        }
        .background(Color(.black))
        .onAppear {
            withAnimation(.easeIn(duration: 1)) {
                self.globalOpacity = 1
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.easeIn(duration: 0.4)) {
                        self.firstOffset = 0
                        self.firstButtonOpacity = 1
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(.easeIn(duration: 0.4)) {
                            self.secondOffset = 0
                            self.secondButtonOpacity = 1
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation(.easeIn(duration: 0.4)) {
                                self.thirdOffset = 0
                                self.thirdButtonOpacity = 1
                            }
                        }
                    }
                }
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    @State private static var setupStep = 0

    static var previews: some View {
        SplashScreen(setupStep: $setupStep).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
