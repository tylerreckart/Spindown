//
//  RuleContext.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/27/23.
//

import SwiftUI

struct RuleContext: View {
    @Binding var selectedRule: Rule?

    var subrules: [Rule] = []
    
    @State private var contentSize: CGSize? = nil

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
                    Image(systemName: "arrow.uturn.left")
                        .font(.system(size: 18, weight: .black))
                    Text("Go Back")
                        .font(.system(size: 18, weight: .black))
                }
            }

            if (self.selectedRule != nil) {
                ScrollView {
                    VStack {
                        if ((selectedRule?.ruleText.split(separator: " ").count)! <= 2) {
                            HStack {
                                Text(selectedRule?.ruleText ?? "")
                                    .font(.system(size: 28, weight: .black))
                                    .multilineTextAlignment(.leading)
                                    .padding(.top, 10)
                                Spacer()
                            }
                        } else {
                            HStack {
                                Text(selectedRule?.ruleText ?? "")
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 10)
                                Spacer()
                            }
                        }
                        
                        if (selectedRule?.examples != nil) {
                            ExamplesContainer(examples: selectedRule?.examples ?? [])
                        }
                        
                        if (self.subrules.count > 0) {
                            VStack(alignment: .leading, spacing: 20) {
                                ForEach(self.subrules.sorted { $0.ruleNumber < $1.ruleNumber }) { subrule in
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
                                            ExamplesContainer(examples: subrule.examples ?? [])
                                        }
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 5)
                        }
                    }
                    .overlay(
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    contentSize = geo.size
                                }
                        }
                    )
                }
            }
        }
        .frame(maxHeight: (contentSize?.height ?? 200) + 40)
        .transition(
            .asymmetric(
                insertion: .push(from: .trailing).combined(with: .opacity),
                removal: .push(from: .leading).combined(with: .opacity)
            )
        )
    }
}
