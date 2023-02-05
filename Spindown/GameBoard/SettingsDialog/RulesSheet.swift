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

public struct RulesBody: Codable, Equatable {
    public static func == (lhs: RulesBody, rhs: RulesBody) -> Bool {
        return lhs.ruleNumber == rhs.ruleNumber
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
    @State private var rules: [String:RulesBody] = [:]
    
    let letters = NSCharacterSet.letters

    var body: some View {
        VStack {
            if (isFetchingRules == false) {
                let keys = rules.map{ $0.key }.sorted()
                let values = rules.map { $0.value }

                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("Rulebook")
                                .font(.system(size: 48, weight: .black))
                            Spacer()
                        }

                        ForEach(Array(keys.indices[0 ..< 100]), id: \.self) { index in
                            let target = values.firstIndex { $0.ruleNumber == keys[index] }
                            VStack(alignment: .leading, spacing: 5) {
                                let data = target != nil ? values[target!] : nil
                                if (data != nil) {
                                    HStack(alignment: .top, spacing: 0) {
                                        Text(keys[index])
                                            .font(.system(size: 18, weight: .bold))
                                            .frame(width: 75, alignment: .leading)
                                        
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text(data?.ruleText ?? "")
                                                .foregroundColor(Color(UIColor(named: "AccentGray") ?? .systemGray5))
                                            
//                                            LinkedRuleNodes(nodes: nodes)
                                            
                                            if (data?.examples != nil) {
                                                RuleExamples(examples: (data?.examples!)!)
                                            }
                                        }
                                        Spacer()
                                    }
                                    .padding(.leading, keys[index].rangeOfCharacter(from: letters) != nil ? 75 : 0)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .padding()
                }
            } else {
                Text("Fethcing Rules... Please hold.")
            }
        }
        .foregroundColor(Color.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .onAppear {
            getRules()
        }
        .onChange(of: self.rules) { newState in
            if newState.count > 0 {
                self.isFetchingRules = false
                print("fetched rules")
            }
        }
    }
    
    func getRules() {
        print("fetching rules")
        let url = URL(string: "https://api.academyruins.com/allrules")!

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            let dRes = try! decoder.decode([String:RulesBody].self, from: data)
            self.rules = dRes
        }

        task.resume()
    }
}

struct RulesSheet_Previews: PreviewProvider {
    static var previews: some View {
        RulesSheet().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
