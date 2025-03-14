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
    @Binding var showOverlay: Bool
    
    @State private var gest: DragGesture = DragGesture(minimumDistance: 5, coordinateSpace: .local)
    
    @State private var greatestFiniteHeight: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .contentShape(Rectangle())
                .gesture(
                    self.gest
                        .onChanged({ gesture in
                            self.showOverlay = true
                            
                            let size = geometry.size
                            let pos = gesture.location.y

                            if (size.width > greatestFiniteHeight) {
                                greatestFiniteHeight = size.height
                            }
                            
                            withAnimation {
                                if (pos > 0) {
                                    let percent =  pos / greatestFiniteHeight
                                    
                                    self.dragCompletionPercentage = percent
                                    self.height = pos
                                }
                            }
                        })
                        .onEnded({ endGesture in
                            withAnimation(.spring()) {
                                if (self.isFullHeight) {
                                    self.height = 0
                                    self.isFullHeight = false
                                    self.dragCompletionPercentage = 0
                                    self.showOverlay = false
                                } else {
                                    self.height = greatestFiniteHeight
                                    self.isFullHeight = true
                                    self.dragCompletionPercentage = 1
                                }
                            }
                        })
                )
        }
    }
}
