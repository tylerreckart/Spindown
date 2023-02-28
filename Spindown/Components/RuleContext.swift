//
//  RuleContext.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/27/23.
//

import SwiftUI

struct RuleContext: View {
    @Binding var selectedRule: Rule?

    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                withAnimation {
                    self.selectedRule = nil
                }
            }) {
                HStack {
                    Text("Rule \(selectedRule?.ruleNumber ?? "")")
                        .font(.system(size: 18, weight: .black))
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Image(systemName: "arrow.backward")
                        .font(.system(size: 18, weight: .black))
                    Text("Go Back")
                        .font(.system(size: 18, weight: .black))
                }
            }

            ScrollView {
                Text(selectedRule?.ruleText ?? "")
                    .multilineTextAlignment(.leading)
                    .padding(.top, 10)
                
                if (selectedRule?.examples != nil) {
                    HStack {
                        Text("Examples")
                            .font(.system(size: 16, weight: .black))
                            .padding(.top)
                            .padding(.bottom, 10)
                        Spacer()
                    }
                    VStack(spacing: 20) {
                        ForEach((selectedRule?.examples!)!, id: \.self) { example in
                            Text(example!)
                                .foregroundColor(Color(UIColor(named: "AccentGray")!))
                                .italic()
                        }
                    }
                }
            }
        }
        .transition(
            .asymmetric(
                insertion: .push(from: .trailing).combined(with: .opacity),
                removal: .push(from: .leading).combined(with: .opacity)
            )
        )
    }
}
