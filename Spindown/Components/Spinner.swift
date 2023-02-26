//
//  Spinner.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/26/23.
//

import SwiftUI

struct Spinner: View {
    @State private var spinning: Bool = false

    var body: some View {
        Image("Spinner")
            .resizable()
            .frame(width: 32, height: 32)
            .rotationEffect(Angle.degrees(spinning ? 360 : 0))
            .animation(.linear(duration: 1).repeatForever(autoreverses: false))
            .onAppear {
                self.spinning = true
            }
            .onDisappear {
                self.spinning = false
            }
    }
}
