//
//  OverlayDragGestureHandler.swift
//  Spindown
//
//  Created by Tyler Reckart on 4/17/23.
//

import SwiftUI

struct OverlayDragGestureHandler: View {
    @Binding var height: CGFloat
    @Binding var isFullHeight: Bool
    @Binding var dragCompletionPercentage: CGFloat
    
    @State private var gest: DragGesture = DragGesture(minimumDistance: 20, coordinateSpace: .local)
    
    @State private var greatestFiniteHeight: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .contentShape(Rectangle())
                .gesture(
                    self.gest
                        .onChanged({ gesture in
                            if (isFullHeight) {
                                self.isFullHeight = false
                            }
                            
                            let size = geometry.size
                            let pos = gesture.location.y

                            if (size.width > greatestFiniteHeight) {
                                greatestFiniteHeight = size.height
                            }
                            
                            withAnimation {
                                if (pos > 0) {
                                    self.dragCompletionPercentage = pos / greatestFiniteHeight
                                    self.height = pos
                                }
                            }
                        })
                        .onEnded({ endGesture in
                            withAnimation(.spring()) {
                                let pos = endGesture.location.y
                                
                                if (pos >= greatestFiniteHeight / 2) {
                                    self.height = greatestFiniteHeight
                                    self.isFullHeight = true
                                } else {
                                    self.height = 0.01
                                    self.isFullHeight = false
                                    self.dragCompletionPercentage = 0
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        self.height = 0
                                    }
                                }
                            }
                        })
                )
        }
    }
}
