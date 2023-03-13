//
//  GameTimer.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/10/23.
//

import SwiftUI

struct GameTimer: View {
    @EnvironmentObject var timerModel: GameTimerModel
    @FocusState private var focused: FocusField?
    @State private var minutes: Float = 30.0
    @Binding var activeView: ActiveSettingsView
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Image(systemName: "stopwatch")
                    .foregroundColor(Color.white)
                    .font(.system(size: 24, weight: .black))
                    .padding(.trailing, 4)
                Text("Game Timer")
                    .font(.system(size: 24, weight: .black))
                    .foregroundColor(Color.white)
                Spacer()
            }
            HStack {
                VStack {
                    VStack {
                        Text(timerModel.running ? timerModel.time : "\(Int(self.minutes)):00")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 52, weight: .black))
                            .focused($focused, equals: .minutes)
                        Text("Minutes")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color(UIColor(named: "AccentGray")!))
                    }
                    .padding(.top, 5)
                    .padding(.bottom, -1)

                    Slider(value: $minutes, in: 1...120)
                }
            }
            .padding(.bottom, 15)
            
            VStack(spacing: 20) {
                HStack(spacing: 20) {
                    UIButton(
                        text: "Start Timer",
                        color: UIColor(named: "PrimaryRed")!,
                        action: { timerModel.start(self.minutes) }
                    )
                    UIButtonOutlined(
                        text: "Reset",
                        fill: UIColor(named: "DeepGray")!,
                        color: UIColor(named: "AccentGray")!,
                        action: timerModel.reset
                    )
                }

                UIButtonOutlined(
                    text: "Go Back",
                    fill: UIColor(named: "DeepGray")!,
                    color: UIColor(named: "AccentGray")!,
                    action: {
                        withAnimation {
                            self.activeView = .home
                        }
                    }
                )
            }
        }
        .foregroundColor(.white)
        .frame(maxWidth: 300)
        .transition(
            .asymmetric(
                insertion: .push(from: .trailing).combined(with: .opacity),
                removal: .push(from: .leading).combined(with: .opacity)
            )
        )
        .onAppear {
            timerModel.update()
        }
    }
}
