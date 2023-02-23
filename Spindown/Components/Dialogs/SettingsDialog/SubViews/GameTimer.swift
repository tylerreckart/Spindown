//
//  GameTimer.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/10/23.
//

import SwiftUI

struct GameTimer: View {
    @Binding var activeView: ActiveSettingsView

    @FocusState private var focused: FocusField?

    @State private var hours: String = ""
    @State private var minutes: String = "30"
    @State private var seconds: String = ""
    
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
                        TextField("", text: $hours)
                            .placeholder(when: self.hours.isEmpty) {
                                VStack(alignment: .center) {
                                    Text("00").foregroundColor(Color(UIColor(named: "AccentGrayDarker")!))
                                        .font(.system(size: 28, weight: .bold))
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .font(.system(size: 28, weight: .black))
                            .focused($focused, equals: .hours)
                    }
                    .padding()
                    .background(Color(UIColor(named: "AccentGrayDarker")!).opacity(0.25))
                    .cornerRadius(4)
                    .padding(4)
                    .background(Color(UIColor(named: "DeepGray")!))
                    .cornerRadius(6)
                    .padding(4)
                    .background(
                        self.focused == .hours ? .white : Color(UIColor(named: "AccentGrayDarker")!)
                    )
                    .cornerRadius(8)
                    
                    Text("Hours")
                        .font(.caption)
                }
                Spacer()
                VStack {
                    HStack {
                        TextField("", text: $minutes)
                            .placeholder(when: self.minutes.isEmpty) {
                                VStack(alignment: .center) {
                                    Text("00").foregroundColor(Color(UIColor(named: "AccentGrayDarker")!))
                                        .font(.system(size: 28, weight: .bold))
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .keyboardType(.numberPad)
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
                }
                Spacer()
                VStack {
                    HStack {
                        TextField("", text: $seconds)
                            .placeholder(when: self.seconds.isEmpty) {
                                VStack(alignment: .center) {
                                    Text("00").foregroundColor(Color(UIColor(named: "AccentGrayDarker")!))
                                        .font(.system(size: 28, weight: .bold))
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .font(.system(size: 28, weight: .black))
                            .focused($focused, equals: .seconds)
                    }
                    .padding()
                    .background(Color(UIColor(named: "AccentGrayDarker")!).opacity(0.25))
                    .cornerRadius(4)
                    .padding(4)
                    .background(Color(UIColor(named: "DeepGray")!))
                    .cornerRadius(6)
                    .padding(4)
                    .background(
                        self.focused == .seconds ? .white : Color(UIColor(named: "AccentGrayDarker")!)
                    )
                    .cornerRadius(8)
                    
                    Text("Seconds")
                        .font(.caption)
                }
            }
            .padding(.bottom, 15)
            
            VStack(spacing: 20) {
                HStack(spacing: 20) {
                    UIButton(text: "Start Timer", color: UIColor(named: "PrimaryRed")!, action: {})
                    UIButtonOutlined(text: "Reset", fill: UIColor(named: "DeepGray")!, color: UIColor(named: "AccentGray")!, action: resetTimer)
                }
                UIButtonOutlined(text: "Go Back", fill: UIColor(named: "DeepGray")!, color: UIColor(named: "AccentGray") ?? .systemGray, action: {
                    withAnimation {
                        self.activeView = .home
                    }
                })
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
    }
    
    func resetTimer() -> Void {
        withAnimation {
            self.focused = nil
            self.hours = ""
            self.minutes = "30"
            self.seconds = ""
        }
    }
}

//struct GameTimer_Previews: PreviewProvider {
//    static var previews: some View {
//        GameTimer().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
