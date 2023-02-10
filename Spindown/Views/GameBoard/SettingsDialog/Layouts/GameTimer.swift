//
//  GameTimer.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/10/23.
//

import SwiftUI

struct GameTimer: View {
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
                                Text("00").foregroundColor(Color(UIColor(named: "AccentGrayDarker")!))
                                    .font(.system(size: 28, weight: .bold))
                            }
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.leading)
                            .font(.system(size: 28, weight: .black))
                            .focused($focused, equals: .quantity)
                    }
                    .padding()
                    .background(Color(UIColor(named: "DeepGray")!))
                    .cornerRadius(4)
                    .padding(4)
                    .background(.black)
                    .cornerRadius(6)
                    .padding(4)
                    .background(
                        Color(UIColor(named: "AccentGrayDarker")!)
                    )
                    .cornerRadius(8)
                    
                    Text("Hours")
                        .font(.caption)
                }
                
                VStack {
                    HStack {
                        TextField("", text: $minutes)
                            .placeholder(when: self.minutes.isEmpty) {
                                Text("00").foregroundColor(Color(UIColor(named: "AccentGrayDarker")!))
                                    .font(.system(size: 28, weight: .bold))
                            }
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.leading)
                            .font(.system(size: 28, weight: .black))
                            .focused($focused, equals: .quantity)
                    }
                    .padding()
                    .background(Color(UIColor(named: "DeepGray")!))
                    .cornerRadius(4)
                    .padding(4)
                    .background(.black)
                    .cornerRadius(6)
                    .padding(4)
                    .background(
                        Color(UIColor(named: "AccentGrayDarker")!)
                    )
                    .cornerRadius(8)
                    
                    Text("Minutes")
                        .font(.caption)
                }
                
                VStack {
                    HStack {
                        TextField("", text: $seconds)
                            .placeholder(when: self.seconds.isEmpty) {
                                Text("00").foregroundColor(Color(UIColor(named: "AccentGrayDarker")!))
                                    .font(.system(size: 28, weight: .bold))
                            }
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.leading)
                            .font(.system(size: 28, weight: .black))
                            .focused($focused, equals: .quantity)
                    }
                    .padding()
                    .background(Color(UIColor(named: "DeepGray")!))
                    .cornerRadius(4)
                    .padding(4)
                    .background(.black)
                    .cornerRadius(6)
                    .padding(4)
                    .background(
                        Color(UIColor(named: "AccentGrayDarker")!)
                    )
                    .cornerRadius(8)
                    
                    Text("Seconds")
                        .font(.caption)
                }
            }
        }
        .foregroundColor(.white)
        .frame(maxWidth: 280)
    }
}

struct GameTimer_Previews: PreviewProvider {
    static var previews: some View {
        GameTimer().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
