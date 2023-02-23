//
//  RulesSheet.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/3/23.
//

import Foundation
import SwiftUI

public struct RulesNavigation: Codable {
    public let previousRule: String?
    public let nextRule: String?
}

class Rule: ObservableObject, Equatable, Identifiable, Hashable {
    var uid: UUID = UUID()
    
    @Published public var ruleNumber: String = ""
    @Published public var examples: [String?]?
    @Published public var ruleText: String = ""
    @Published public var fragment: String?
    @Published public var navigation: RulesNavigation?
    
    static func == (lhs: Rule, rhs: Rule) -> Bool {
        return lhs.uid == rhs.uid
    }
    
    public func hash(into hasher: inout Hasher) -> Void {
        hasher.combine(uid)
    }
}

struct RulesSheet: View {
    @State private var isFetchingRules: Bool = false

    @State private var rules: [Rule] = []
    @State private var currentPage: Int = 1
    
    let letters = NSCharacterSet.letters

    var body: some View {
        VStack {
            HStack {
                Text("Rulebook")
                    .font(.system(size: 32, weight: .black))
                Spacer()
                HStack {
                    Image(systemName: "magnifyingglass")
                    Text("Search for a rule")
                }
            }
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(rules.sorted { $0.ruleNumber < $1.ruleNumber }, id: \.self) { rule in
                        HStack(alignment: .top, spacing: 0) {
                            let subrule = rule.ruleNumber.rangeOfCharacter(from: letters)
                            
                            if (subrule == nil) {
                                HStack {
                                    Text(rule.ruleNumber)
                                        .font(.system(size: 18, weight: .black))
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                                .frame(width: 80)
                            } else {
                                Text(rule.ruleNumber)
                                    .font(.system(size: 18, weight: .bold))
                                    .padding(.leading, 100)
                                    .padding(.trailing, 20)
                                    .multilineTextAlignment(.leading)
                            }
                            Text(rule.ruleText)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    }
                }
            }
            
            HStack {
                Button(action: {
                    if (self.currentPage != 1) {
                        self.currentPage -= 1
                    }
                }) {
                    Text("Prev Page")
                }
                
                Spacer()

                Button(action: {
                    if (self.currentPage != 9) {
                        self.currentPage += 1
                    }
                    
                }) {
                    Text("Next Page")
                }
            }
        }
        .foregroundColor(Color.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .onAppear {
            getRules()
        }
        .onChange(of: currentPage) { newState in
            getRules()
        }
    }
    
    func getRules() {
        self.rules = []
        print("fetch ruleset \(self.currentPage)00")
        if let path = Bundle.main.path(forResource: "\(self.currentPage)00", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                    for (_, rule) in jsonResult {
                        let obj = Rule()
                        obj.ruleNumber = (rule["ruleNumber"] as? String)!
                        obj.examples = rule["examples"] as? [String?]
                        obj.ruleText = (rule["ruleText"] as? String)!
                        obj.fragment = rule["fragment"] as? String
                        obj.navigation = rule["navigation"] as? RulesNavigation
                        
                        self.rules.append(obj)
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
