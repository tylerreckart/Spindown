//
//  Dialog.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/2/23.
//

import SwiftUI

struct Dialog<Content: View>: View {
    @ViewBuilder var content: Content
    
    var maxWidth: CGFloat = 475
    @Binding var open: Bool
    
    @State private var overlayOpacity: CGFloat = 0
    
    var placement: DialogPlacement = .center
    
    var body: some View {
        ZStack {
            Color.black.opacity(overlayOpacity)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        self.open.toggle()
                    }
                }
    
            if (open) {
                VStack {
                    if (placement == .bottom || placement == .center) {
                        Spacer()
                    }
                    
                    content
                        .frame(maxWidth: maxWidth)
                        .padding(30)
                        .background(Color(UIColor(named: "DeepGray")!))
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.1), radius: 15)
                    
                    if (placement == .top || placement == .center) {
                        Spacer()
                    }
                }
                .padding(
                    placement == .top ? .top :
                        placement == .bottom ? .bottom : .all,
                    placement == .top || placement == .bottom ? 25 : 0
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(
                    .asymmetric(
                        insertion: .scale(scale: 0.6).combined(with: .opacity),
                        removal: .scale(scale: 0.6).combined(with: .opacity)
                    )
                )
                .zIndex(1000)
            }
        }
        .onChange(of: open) { newState in
            if (newState == true) {
                withAnimation(.linear(duration: 0.4)) {
                    self.overlayOpacity = 0.4
                }
            } else {
                withAnimation(.linear(duration: 0.4)) {
                    self.overlayOpacity = 0
                }
            }
        }
    }
}
