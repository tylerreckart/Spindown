//
//  ChangeLayout.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/2/23.
//

import SwiftUI

struct PersonCard: View {
    var rotation: Double
    var width: CGFloat
    var height: CGFloat

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(UIColor(named: "AccentGrayDarker") ?? .systemGray))
                .frame(width: width, height: height)
                .cornerRadius(6)
                .overlay(LinearGradient(colors: [Color.white.opacity(0.1), .clear], startPoint: .top, endPoint: .bottom))
            Image(systemName: "person.fill")
                .foregroundColor(Color(UIColor(named: "AccentGray") ?? .systemGray))
                .font(.system(size: 20, weight: .black))
                .rotationEffect(Angle(degrees: rotation))
                .shadow(color: Color.black.opacity(0.4), radius: 8)
        }
    }
}

struct TwoPlayerLayoutCard: View {
    var p1Rotation: CGFloat = 0
    var p2Rotation: CGFloat = 0
    var layout: BoardLayout
    
    @Binding var selectedLayout: BoardLayout

    var body: some View {
        VStack {
            Button(action: {
                self.selectedLayout = layout
            }) {
                VStack(spacing: 6) {
                    PersonCard(rotation: p1Rotation, width: 60, height: 40)
                    PersonCard(rotation: p2Rotation, width: 60, height: 40)
                }
                .padding(11)
                .background(
                    Color(.systemGray)
                        .overlay(LinearGradient(colors: [Color.white.opacity(0.2), .clear], startPoint: .top, endPoint: .bottom))
                        .overlay(RoundedRectangle(cornerRadius: 8).fill(Color.black).padding(4))
                )
                .cornerRadius(12)
            }
            
            Image(systemName: self.selectedLayout == layout ? "checkmark.circle.fill" : "circle")
                .foregroundColor(self.selectedLayout == layout ? Color.white : Color(UIColor(named: "AccentGrayDarker") ?? .systemGray))
                .font(.system(size: 18, weight: .black))
                .padding(.top, 5)
        }
    }
}

struct ThreePlayerLayoutCard: View {
    var p1Rotation: CGFloat = 0
    var p2Rotation: CGFloat = 0
    var p3Rotation: CGFloat = 0
    var layout: BoardLayout
    
    @Binding var selectedLayout: BoardLayout

    var body: some View {
        Button(action: {
            self.selectedLayout = layout
        }) {
            VStack {
                VStack {
                    if (self.layout == .tandem) {
                        HStack(spacing: 6) {
                            PersonCard(rotation: p1Rotation, width: 40, height: 86)
                            PersonCard(rotation: p2Rotation, width: 40, height: 86)
                            PersonCard(rotation: p3Rotation, width: 40, height: 86)
                        }
                    }
                    if (self.layout == .facingPortrait) {
                        VStack(spacing: 6) {
                            HStack(spacing: 6) {
                                PersonCard(rotation: p1Rotation, width: 40, height: 41)
                                PersonCard(rotation: p2Rotation, width: 40, height: 41)
                            }
                            PersonCard(rotation: p3Rotation, width: 86, height: 41)
                        }
                    }
                }
                .padding(11)
                .background(
                    Color(UIColor(named: "AccentGray") ?? .systemGray)
                        .overlay(LinearGradient(colors: [Color.white.opacity(0.2), .clear], startPoint: .top, endPoint: .bottom))
                        .overlay(RoundedRectangle(cornerRadius: 8).fill(Color.black).padding(4))
                )
                .cornerRadius(12)
                
                Image(systemName: self.selectedLayout == layout ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(self.selectedLayout == layout ? Color.white : Color(UIColor(named: "AccentGrayDarker") ?? .systemGray))
                    .font(.system(size: 18, weight: .black))
                    .padding(.top, 5)
            }
        }
    }
}

struct FourPlayerLayoutCard: View {
    var p1Rotation: Double = 0
    var p2Rotation: Double = 0
    var p3Rotation: Double = 0
    var p4Rotation: Double = 0
    var layout: BoardLayout
    
    @Binding var selectedLayout: BoardLayout

    var body: some View {
        VStack {
            Button(action: {
                self.selectedLayout = layout
            }) {
                VStack {
                    VStack {
                        if (self.layout == .tandem) {
                            VStack(spacing: 6) {
                                HStack(spacing: 6) {
                                    PersonCard(rotation: p1Rotation, width: 40, height: 41)
                                    PersonCard(rotation: p2Rotation, width: 40, height: 41)
                                }
                                HStack(spacing: 6) {
                                    PersonCard(rotation: p3Rotation, width: 40, height: 41)
                                    PersonCard(rotation: p4Rotation, width: 40, height: 41)
                                }
                            }
                        } else if (self.layout == .facingLandscape) {
                            HStack(spacing: 6) {
                                PersonCard(rotation: p1Rotation, width: 40, height: 86)
                                VStack(spacing: 6) {
                                    PersonCard(rotation: p2Rotation, width: 40, height: 40)
                                    PersonCard(rotation: p3Rotation, width: 40, height: 40)
                                }
                                PersonCard(rotation: p4Rotation, width: 40, height: 86)
                            }
                        }
                    }
                    .padding(11)
                    .background(
                        Color(UIColor(named: "AccentGray") ?? .systemGray)
                            .overlay(LinearGradient(colors: [Color.white.opacity(0.2), .clear], startPoint: .top, endPoint: .bottom))
                            .overlay(RoundedRectangle(cornerRadius: 8).fill(Color.black).padding(4))
                    )
                    .cornerRadius(12)
                    
                    Image(systemName: self.selectedLayout == layout ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(self.selectedLayout == layout ? Color.white : Color(UIColor(named: "AccentGrayDarker") ?? .systemGray))
                        .font(.system(size: 18, weight: .black))
                        .padding(.top, 5)
                }
            }
        }
    }
}

struct SixPlayerLayoutCard: View {
    var p1Rotation: Double = 0
    var p2Rotation: Double = 0
    var p3Rotation: Double = 0
    var p4Rotation: Double = 0
    var p5Rotation: Double = 0
    var p6Rotation: Double = 0
    var layout: BoardLayout
    
    @Binding var selectedLayout: BoardLayout

    var body: some View {
        VStack {
            Button(action: {
                self.selectedLayout = layout
            }) {
                VStack {
                    VStack {
                        if (self.layout == .tandem) {
                            VStack(spacing: 6) {
                                HStack(spacing: 6) {
                                    PersonCard(rotation: p1Rotation, width: 40, height: 41)
                                    PersonCard(rotation: p2Rotation, width: 40, height: 41)
                                }
                                HStack(spacing: 6) {
                                    PersonCard(rotation: p3Rotation, width: 40, height: 41)
                                    PersonCard(rotation: p4Rotation, width: 40, height: 41)
                                }
                                HStack(spacing: 6) {
                                    PersonCard(rotation: p5Rotation, width: 40, height: 41)
                                    PersonCard(rotation: p6Rotation, width: 40, height: 41)
                                }
                            }
                        } else if (self.layout == .facingLandscape) {
                            VStack(spacing: 6) {
                                PersonCard(rotation: p1Rotation, width: 86, height: 30)
                                HStack(spacing: 6) {
                                    PersonCard(rotation: p2Rotation, width: 40, height: 29)
                                    PersonCard(rotation: p3Rotation, width: 40, height: 29)
                                }
                                HStack(spacing: 6) {
                                    PersonCard(rotation: p4Rotation, width: 40, height: 29)
                                    PersonCard(rotation: p5Rotation, width: 40, height: 29)
                                }
                                PersonCard(rotation: p6Rotation, width: 86, height: 30)
                            }
                        }
                    }
                    .padding(11)
                    .background(
                        Color(UIColor(named: "AccentGray") ?? .systemGray)
                            .overlay(LinearGradient(colors: [Color.white.opacity(0.2), .clear], startPoint: .top, endPoint: .bottom))
                            .overlay(RoundedRectangle(cornerRadius: 8).fill(Color.black).padding(4))
                    )
                    .cornerRadius(12)
                    
                    Image(systemName: self.selectedLayout == layout ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(self.selectedLayout == layout ? Color.white : Color(UIColor(named: "AccentGrayDarker") ?? .systemGray))
                        .font(.system(size: 18, weight: .black))
                        .padding(.top, 5)
                }
            }
        }
    }
}

struct TwoPlayerLayoutContainer: View {
    @Binding var selectedLayout: BoardLayout

    var body: some View {
        HStack(spacing: 0) {
            TwoPlayerLayoutCard(p1Rotation: 90, p2Rotation: 90, layout: .tandem, selectedLayout: $selectedLayout)
            Spacer()
            TwoPlayerLayoutCard(p1Rotation: 90, p2Rotation: -90, layout: .facingLandscape, selectedLayout: $selectedLayout)
            Spacer()
            TwoPlayerLayoutCard(p1Rotation: 180, p2Rotation: 0, layout: .facingPortrait, selectedLayout: $selectedLayout)
        }
    }
}

struct ThreePlayerLayoutContainer: View {
    @Binding var selectedLayout: BoardLayout

    var body: some View {
        HStack(spacing: 0) {
            ThreePlayerLayoutCard(p1Rotation: -180, p2Rotation: -180, p3Rotation: 0, layout: .facingPortrait, selectedLayout: $selectedLayout)
            Spacer()
            ThreePlayerLayoutCard(p1Rotation: 0, p2Rotation: 0, p3Rotation: 0, layout: .tandem, selectedLayout: $selectedLayout)
        }
    }
}

struct FourPlayerLayoutContainer: View {
    @Binding var selectedLayout: BoardLayout

    var body: some View {
        HStack(spacing: 0) {
            FourPlayerLayoutCard(p1Rotation: -180, p2Rotation: -180, p3Rotation: 0, p4Rotation: 0, layout: .tandem, selectedLayout: $selectedLayout)
            Spacer()
            FourPlayerLayoutCard(p1Rotation: -90, p2Rotation: -180, p3Rotation: 0, p4Rotation: -90, layout: .facingLandscape, selectedLayout: $selectedLayout)
        }
    }
}

struct SixPlayerLayoutContainer: View {
    @Binding var selectedLayout: BoardLayout

    var body: some View {
        HStack(spacing: 0) {
            SixPlayerLayoutCard(p1Rotation: 90, p2Rotation: -90, p3Rotation: 90, p4Rotation: -90, p5Rotation: 90, p6Rotation: -90, layout: .tandem, selectedLayout: $selectedLayout)
            Spacer()
            SixPlayerLayoutCard(p1Rotation: -180, p2Rotation: 90, p3Rotation: -90, p4Rotation: 90, p5Rotation: -90, p6Rotation: 0, layout: .facingLandscape, selectedLayout: $selectedLayout)
        }
        .frame(maxWidth: 260)
    }
}

struct LayoutSelectorView: View {
    @Binding var activeView: ActiveSettingsView
    @Binding var selectedLayout: BoardLayout
    
    var playerCount: Int

    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Image(systemName: "uiwindow.split.2x1")
                    .foregroundColor(Color.white)
                    .font(.system(size: 24, weight: .black))
                    .padding(.trailing, 4)
                Text("Change Layout")
                    .font(.system(size: 24, weight: .black))
                    .foregroundColor(Color.white)
                Spacer()
            }
            VStack(spacing: 20) {
                if (self.playerCount == 2) {
                    TwoPlayerLayoutContainer(selectedLayout: $selectedLayout)
                } else if (self.playerCount == 3) {
                    ThreePlayerLayoutContainer(selectedLayout: $selectedLayout)
                }else if (self.playerCount == 4) {
                    FourPlayerLayoutContainer(selectedLayout: $selectedLayout)
                } else if (self.playerCount == 6) {
                    SixPlayerLayoutContainer(selectedLayout: $selectedLayout)
                }
                
                VStack(spacing: 10) {
                    UIButtonOutlined(text: "Go Back", fill: .black, color: UIColor(named: "AccentGray") ?? .systemGray, action: {
                        withAnimation {
                            self.activeView = .home
                        }
                    })
                }
            }
        }
        .frame(maxWidth: 300)
    }
}
