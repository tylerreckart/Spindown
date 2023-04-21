//
//  OrientationListener.swift
//  Spindown
//
//  Created by Tyler Reckart on 4/21/23.
//

import SwiftUI

struct OrientationOverlay<Content: View>: View {
    @ViewBuilder var content: Content
    
    var targetOrientation: UIDeviceOrientation? = .portrait

    let orientationListener = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
        .makeConnectable()
        .autoconnect()
    
    @State private var orientation: UIDeviceOrientation?
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .edgesIgnoringSafeArea(.all)

            if (orientation == targetOrientation) {
                content
            } else {
                VStack {
                    Text("Rotate device")
                }
                .transition(.opacity)
            }
        }
        .transition(.opacity.combined(with: .scale(scale: 0.8)))
        .onAppear {
            if (UIDevice.current.orientation.isLandscape) {
                self.orientation = .landscapeLeft
            } else {
                self.orientation = .portrait
            }
        }
        .onReceive(orientationListener) { _ in
            self.orientation = UIDevice.current.orientation
        }
    }
}
