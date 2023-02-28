//
//  RuleContext.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/27/23.
//

import SwiftUI

struct Examples: View {
    var examples: [String?]

    var body: some View {
        HStack {
            Text("Examples")
                .font(.system(size: 16, weight: .black))
                .padding(.top)
                .padding(.bottom, 10)
            Spacer()
        }
        VStack(spacing: 20) {
            ForEach(examples, id: \.self) { example in
                Text(example!)
                    .foregroundColor(Color(UIColor(named: "AccentGray")!))
                    .italic()
            }
        }
    }
}

struct RuleContext: View {
    @Binding var selectedRule: Rule?

    var subrules: [Rule] = []

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

            if (self.selectedRule != nil) {
                ScrollView {
                    if ((selectedRule?.ruleText.split(separator: " ").count)! <= 2) {
                        Text(selectedRule?.ruleText ?? "")
                            .font(.system(size: 24, weight: .black))
                            .multilineTextAlignment(.leading)
                            .padding(.top, 10)
                    } else {
                        Text(selectedRule?.ruleText ?? "")
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 10)
                    }
                    
                    if (selectedRule?.examples != nil) {
                        Examples(examples: (selectedRule?.examples!)!)
                    }
                    
                    if (self.subrules.count > 0) {
                        VStack(alignment: .leading, spacing: 20) {
                            ForEach(self.subrules) { subrule in
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(subrule.ruleNumber)
                                        .font(.system(size: 18, weight: .black))
                                        .multilineTextAlignment(.leading)
                                    HStack {
                                        Text(subrule.ruleText)
                                            .multilineTextAlignment(.leading)
                                        Spacer()
                                    }
                                    
                                    if (subrule.examples != nil) {
                                        Examples(examples: (subrule.examples!))
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 5)
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
