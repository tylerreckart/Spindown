//
//  GameSettingsDialog.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/2/23.
//

import SwiftUI

struct GameSettingsScreen_Previews: PreviewProvider {
    @State static var activeView: ActiveSettingsView = .layout
    @State static var selectedLayout: BoardLayout = .tandem
    
    static var playerCount: Int = 4
    
    static var previews: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                LayoutSelectorView(activeView: $activeView, selectedLayout: $selectedLayout, playerCount: playerCount).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                Spacer()
            }
            Spacer()
        }
        .background(.black)
    }
}


struct DiceRollView: View {
    var body: some View {
        Text("Dice Roll")
    }
}

struct TimerView: View {
    var body: some View {
        Text("Timer")
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
                    ZStack {
                        Rectangle()
                            .fill(Color(UIColor(named: "AccentGrayDarker") ?? .systemGray))
                            .frame(width: 60, height: 40)
                            .cornerRadius(6)
                            .overlay(LinearGradient(colors: [Color.white.opacity(0.1), .clear], startPoint: .top, endPoint: .bottom))
                        Image(systemName: "person.fill")
                            .foregroundColor(Color(UIColor(named: "AccentGray") ?? .systemGray))
                            .font(.system(size: 20, weight: .black))
                            .rotationEffect(Angle(degrees: p1Rotation))
                            .shadow(color: Color.black.opacity(0.4), radius: 8)
                    }
                    
                    ZStack {
                        Rectangle()
                            .fill(Color(UIColor(named: "AccentGrayDarker") ?? .systemGray))
                            .overlay(LinearGradient(colors: [Color.white.opacity(0.1), .clear], startPoint: .top, endPoint: .bottom))
                            .frame(width: 60, height: 40)
                            .cornerRadius(6)
                        Image(systemName: "person.fill")
                            .foregroundColor(Color(UIColor(named: "AccentGray") ?? .systemGray))
                            .font(.system(size: 20, weight: .black))
                            .rotationEffect(Angle(degrees: p2Rotation))
                            .shadow(color: Color.black.opacity(0.4), radius: 8)
                    }
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
                } else if (self.playerCount == 4) {
                    FourPlayerLayoutContainer(selectedLayout: $selectedLayout)
                } else if (self.playerCount == 6) {
                    SixPlayerLayoutContainer(selectedLayout: $selectedLayout)
                }
                
                VStack(spacing: 10) {
                    UIButtonOutlined(text: "Save", fill: .black, color: UIColor(named: "AccentGray") ?? .systemGray, action: {
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

struct FormatSelectorView: View {
    var body: some View {
        Text("Format")
    }
}

struct PlayerSelectorView: View {
    var body: some View {
        Text("Player")
    }
}

struct GameSettingsHomeView: View {
    var endGame: () -> ()
    var dismissModal: () -> ()
    
    @Binding var activeView: ActiveSettingsView
    
    var playerCount: Int

    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Text("Settings")
                    .font(.system(size: 24, weight: .black))
                    .foregroundColor(Color.white)
                Spacer()
            }
            
            VStack(spacing: 15) {
                HStack(spacing: 15) {
                    UIButtonStacked(text: "Timer", symbol: "stopwatch", color: UIColor(named: "AccentGrayDarker") ?? .systemGray, action: {
                        withAnimation {
                            self.activeView = .timer
                        }
                    })
                    UIButtonStacked(text: "Roll Dice", symbol: "dice", color: UIColor(named: "AccentGrayDarker") ?? .systemGray, action: {
                        withAnimation {
                            self.activeView = .roll
                        }
                    })
                    UIButtonStacked(text: "Rules", symbol: "book", color: UIColor(named: "AccentGrayDarker") ?? .systemGray, action: {})
                }
                if (self.playerCount == 2 || self.playerCount == 4 || self.playerCount == 6) {
                    UIButtonOutlined(text: "Change Layout", symbol: "uiwindow.split.2x1", fill: .black, color: UIColor(named: "AccentGray")!, action: {
                        withAnimation {
                            self.activeView = .layout
                        }
                    })
                }
                UIButtonOutlined(text: "Change Format", symbol: "text.book.closed", fill: .black, color: UIColor(named: "AccentGray")!, action: {
                    withAnimation {
                        self.activeView = .format
                    }
                })
                UIButtonOutlined(text: "Change Players", symbol: "person.2", fill: .black, color: UIColor(named: "AccentGray")!, action: {
                    withAnimation {
                        self.activeView = .player
                    }
                })
                UIButton(text: "End Game", symbol: "xmark", color: UIColor(named: "PrimaryRed") ?? .systemGray, action: {
                    dismissModal()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        endGame()
                    }
                })
            }
            .frame(maxWidth: 300)
        }
    }
}

enum ActiveSettingsView {
    case home
    case roll
    case timer
    case layout
    case format
    case player
}

struct GameSettingsDialog: View {
    @Binding var open: Bool
    @Binding var selectedLayout: BoardLayout
    
    var endGame: () -> ()
    
    var playerCount: Int

    @State private var overlayOpacity: CGFloat = 0
    @State private var dialogOpacity: CGFloat = 0
    @State private var dialogOffset: CGFloat = 0.75
    
    @State private var activeView: ActiveSettingsView = .home
    
    var body: some View {
        ZStack {
            Color.black.opacity(overlayOpacity)
                .onTapGesture {
                    dismissModal()
                }
            
            VStack {
                switch (activeView) {
                    case .home:
                        GameSettingsHomeView(endGame: endGame, dismissModal: dismissModal, activeView: $activeView, playerCount: playerCount)
                    case .roll:
                        DiceRollView()
                    case .timer:
                        TimerView()
                    case .layout:
                        LayoutSelectorView(activeView: $activeView, selectedLayout: $selectedLayout, playerCount: playerCount)
                    case .format:
                        FormatSelectorView()
                    case .player:
                        PlayerSelectorView()
                }
            }
            .frame(maxWidth: 300)
            .padding(30)
            .background(
                Color(.black)
                    .overlay(LinearGradient(colors: [.white.opacity(0.05), .clear], startPoint: .top, endPoint: .bottom))
            )
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 15)
            .opacity(dialogOpacity)
            .scaleEffect(dialogOffset)
            .onAppear {
                UIApplication.shared.isIdleTimerDisabled = true

                withAnimation {
                    self.overlayOpacity = 0.5
                    self.dialogOpacity = 1
                    self.dialogOffset = 1.1
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation {
                            self.dialogOffset = 1
                        }
                    }
                }
            }
            .onDisappear {
                UIApplication.shared.isIdleTimerDisabled = false
            }
        }
    }
    
    func dismissModal() {
        withAnimation {
            self.overlayOpacity = 0
            self.dialogOpacity = 0
            self.dialogOffset = 0.75
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            open.toggle()
        }
    }
}
