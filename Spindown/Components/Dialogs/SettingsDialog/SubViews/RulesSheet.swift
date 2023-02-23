//
//  RulesSheet.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/3/23.
//

import Foundation
import SwiftUI

extension String {
    func markdownToAttributed() -> AttributedString {
        do {
            return try AttributedString(markdown: self)
        } catch {
            return AttributedString("Error parsing markdown: \(error)")
        }
    }
}

public struct RulesResponse: Codable {
    public let rules: [String:[RulesBody]]
}

public struct RulesNavigation: Codable {
    public let previousRule: String?
    public let nextRule: String?
}

public struct RulesBody: Codable, Equatable, Hashable {
    public static func == (lhs: RulesBody, rhs: RulesBody) -> Bool {
        return lhs.ruleNumber == rhs.ruleNumber
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ruleNumber)
        hasher.combine(ruleText)
    }
    
    public let ruleNumber: String?
    public let examples: [String?]?
    public let ruleText: String?
    public let fragment: String?
    public let navigation: RulesNavigation?
}

struct LinkedRuleNodes: View {
    var nodes: [String]

    var body: some View {
        VStack {
            ForEach(nodes.indices, id: \.self) { j in
                Text(nodes[j])
                    .foregroundColor(Color.red)
            }
        }
    }
}

struct RuleExamples: View {
    var examples: [String?]

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Examples")
                .font(.system(size: 18, weight: .bold))
            VStack(spacing: 5) {
                ForEach(examples, id: \.self) { example in
                    Text(example!)
                        .italic()
                        .foregroundColor(Color(UIColor(named: "AccentGray") ?? .systemGray5))
                }
            }
        }
    }
}

extension AnyView {
    static func + (left: AnyView, right: AnyView) -> AnyView{
        return AnyView(
            HStack(spacing: 0) {
                left.fixedSize(horizontal: false, vertical: false)
                right.fixedSize(horizontal: false, vertical: false)
            }
        )
    }
}

struct RulesSheet: View {
    @State private var isFetchingRules: Bool = false

    @State private var rules: [RulesBody] = []
    
    let letters = NSCharacterSet.letters

    var body: some View {
        VStack {
            HStack {
                Text("Rulebook")
                    .font(.system(size: 48, weight: .black))
                Spacer()
            }
            ScrollView {
                ForEach(rules, id: \.self) { rule in
                    VStack {
                        Text(rule.ruleNumber!)
                        Text(rule.ruleText!)
                    }
                    
                }
            }
        }
        .foregroundColor(Color.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .onAppear {
            getRules()
        }
    }
    
    func getRules() {
        if let path = Bundle.main.path(forResource: "100", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                    for (_, rule) in jsonResult {
                        let obj = rule as? RulesBody ?? nil
                        // rule needs to be decoded into the object structure. this currently always returns nil
                        
                        if obj != nil {
                            self.rules.append((rule as? RulesBody)!)
                        }
                    }
                }
            } catch {
               // handle error
            }
        }
    }
}

struct RulesSheet_Previews: PreviewProvider {
    static var previews: some View {
        RulesSheet().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
