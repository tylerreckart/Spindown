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
                    Image(systemName: "arrow.backward")
                        .font(.system(size: 18, weight: .black))
                    Text("Go Back")
                        .font(.system(size: 18, weight: .black))
                }
            }

            if (self.selectedRule != nil) {
                RuleBody(rule: self.selectedRule!, subrules: subrules)
            }
        }
        .frame(maxHeight: contentSize?.height ?? 200)
        .transition(
            .asymmetric(
                insertion: .push(from: .trailing).combined(with: .opacity),
                removal: .push(from: .leading).combined(with: .opacity)
            )
        )
    }
}
