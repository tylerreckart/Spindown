//
//  SettingsSheet.swift
//  Spindown
//
//  Created by Tyler Reckart on 4/20/23.
//

import SwiftUI

struct SettingsOverlayView: View {
    @Binding var open: Bool

    var body: some View {
        OrientationOverlay(content: {
            VStack {
                Button(action: { self.open.toggle() }) {
                    Text("Close")
                }
                
                Text("Hello, world!")
                    .padding()
            }
        }, targetOrientation: .portrait)
    }
}
