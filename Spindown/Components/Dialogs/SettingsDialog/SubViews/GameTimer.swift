//
//  GameTimer.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/10/23.
//

import SwiftUI

struct GameTimer: View {
    @EnvironmentObject var timerModel: GameTimerModel
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
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
                    HStack {
                        Text("\(Int(self.minutes)):00")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 28, weight: .black))
                            .focused($focused, equals: .minutes)
                    }
                    .padding()
                    .background(Color(UIColor(named: "AccentGrayDarker")!).opacity(0.25))
                    .cornerRadius(4)
                    .padding(4)
                    .background(Color(UIColor(named: "DeepGray")!))
                    .cornerRadius(6)
                    .padding(4)
                    .background(
                        self.focused == .minutes ? .white : Color(UIColor(named: "AccentGrayDarker")!)
                    )
                    .cornerRadius(8)
                    
                    Text("Minutes")
                        .font(.caption)
                    
                    Slider(value: $minutes, in: 1...100)
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
        .onReceive(timer) { _ in
            timerModel.update()
        }
    }
}

//struct GameTimer_Previews: PreviewProvider {
//    static var previews: some View {
//        GameTimer().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
