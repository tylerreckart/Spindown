//
//  PlayerTileOptionsOverlay.swift
//  Spindown
//
//  Created by Tyler Reckart on 4/17/23.
//

import SwiftUI

struct PlayerTileOptionsOverlay: View {
    @Binding var height: CGFloat
    @Binding var completionPercentage: CGFloat
    @Binding var isFullHeight: Bool
    
    var body: some View {
        ZStack {
            VStack {
                Rectangle().fill(.ultraThinMaterial)
                    .edgesIgnoringSafeArea(.all)
                    .shadow(color: .black.opacity(0.1), radius: 3)
                    .frame(maxWidth: .infinity, maxHeight: height)
                    .zIndex(2)
                
                if (!isFullHeight) {
                    Spacer()
                }
            }
            
            OverlayDragGestureHandler(height: $height, isFullHeight: $isFullHeight, dragCompletionPercentage: $completionPercentage)
            
            if (isFullHeight) {
                VStack {
                    ZStack {
                        VStack {
                            Spacer()
                            
                            Image(systemName: "chevron.compact.up")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white.opacity(0.2))
                                .padding(10)
                                .shadow(color: .black.opacity(0.1), radius: 2)
                                .transition(.push(from: .leading))
                        }
                        
                        HStack(spacing: 20) {
                            VStack {
                                Spacer()
                                Image(systemName: "figure.run.circle.fill")
                                    .font(.system(size: 32))
                                Spacer()
                                Text("Commander")
                                    .font(.system(size: 7.4, weight: .black))
                                Text("Damage")
                                    .font(.system(size: 12, weight: .black))
                                Spacer()
                            }
                            .padding(12)
                            .frame(width: 80, height: 90)
                            .textCase(.uppercase)
                            .background(.clear)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(LinearGradient(colors: [.white.opacity(0.3), .white.opacity(0.2)], startPoint: .top, endPoint: .bottom), lineWidth: 4)
                                    .shadow(radius: 3)
                            )
                            
                            VStack {
                                Spacer()
                                Image(systemName: "paintpalette.fill")
                                    .font(.system(size: 32))
                                Spacer()
                                Text("Customize")
                                    .font(.system(size: 7.4, weight: .black))
                                Text("Player")
                                    .font(.system(size: 12, weight: .black))
                                Spacer()
                            }
                            .padding(12)
                            .frame(width: 80, height: 90)
                            .textCase(.uppercase)
                            .background(.clear)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(LinearGradient(colors: [.white.opacity(0.3), .white.opacity(0.2)], startPoint: .top, endPoint: .bottom), lineWidth: 4)
                                    .shadow(radius: 3)
                            )
                        }
                    }
                    
                    if (!isFullHeight) {
                        Spacer()
                    }
                }
            }
        }
    }
}
