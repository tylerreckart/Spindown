//
//  RulesSheet.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/3/23.
//

import Foundation
import SwiftUI

struct RulesSheet: View {
    @State private var isFetchingRules: Bool = false

    @State private var rules: [Rule] = []
    @State private var currentPage: Int = 1
    
    let letters = NSCharacterSet.letters
    
    @State private var showSearchDialog: Bool = false
    @State private var searchText: String = ""
    @State private var searchResults: [Rule] = []
    @State private var spinning: Bool = false
    @State private var selectedRule: Rule?
    @State private var selectedRuleSubrules: [Rule] = []

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Image(systemName: "book")
                        .font(.system(size: 24, weight: .black))
                    Text("Rulebook")
                        .font(.system(size: 28, weight: .black))
                    Spacer()
                    
                    UIButtonOutlined(
                        text: "Search",
                        symbol: "magnifyingglass",
                        fill: UIColor(named: "NotAsDeepGray")!,
                        color: UIColor(named: "AccentGray")!,
                        action: {
                            withAnimation {
                                self.showSearchDialog.toggle()
                            }
                        }
                    )
                    .frame(maxWidth: 125, maxHeight: 50)
                }
                .padding()
                .background(Color(UIColor(named: "NotAsDeepGray")!).opacity(0.75))

                Divider()
                    .frame(height: 4)
                    .background(Color(UIColor(named: "AccentGrayDarker")!))
                    .overlay(LinearGradient(colors: [.white.opacity(0.1), .clear], startPoint: .top, endPoint: .bottom))
                    .offset(y: -8)

                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(rules.sorted { $0.ruleNumber < $1.ruleNumber }, id: \.self) { rule in
                            VStack(alignment: .leading, spacing: 0) {
                                let subrule = rule.ruleNumber.rangeOfCharacter(from: letters)
                                
                                Text(rule.ruleNumber)
                                    .font(.system(size: 18, weight: .black))
                                    .padding(.leading, subrule != nil ? 50 : 0)
                                    .multilineTextAlignment(.leading)
                                HStack {
                                    Text(rule.ruleText)
                                        .multilineTextAlignment(.leading)
                                        .padding(.leading, subrule != nil ? 50 : 0)
                                    Spacer()
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding()
                }
                .padding([.top, .bottom], -16)
            }
            
            SearchDialog(
                open: $showSearchDialog,
                searchText: $searchText,
                results: $searchResults,
                selectedRule: $selectedRule,
                subrules: selectedRuleSubrules
            )
        }
        .foregroundColor(Color.white)
        .background(Color(UIColor(named: "DeepGray")!))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            getRules()
        }
        .onChange(of: currentPage) { newState in
            getRules()
        }
        .onChange(of: searchText) { newState in
            search()
        }
        .onChange(of: selectedRule) { newState in
            if (self.selectedRule != nil) {
                let subruleMatches = self.rules.filter({
                    $0.ruleNumber.lowercased() != self.selectedRule?.ruleNumber.lowercased() &&
                    $0.ruleNumber.lowercased().contains((self.selectedRule?.ruleNumber.lowercased())!)
                })
                
                self.selectedRuleSubrules = subruleMatches
            } else {
                self.selectedRuleSubrules = []
            }
        }
        .onChange(of: showSearchDialog) { newState in
            if (newState == false && self.searchText.count > 0) {
                self.searchText = ""
            }
        }
    }
    
    func getRules() {
        self.spinning = true
        self.rules = []

        DispatchQueue.main.async {
            for page in 1...9 {
                if let path = Bundle.main.path(forResource: "\(page)00", ofType: "json") {
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
                            
                            self.spinning = false
                        }
                    } catch {
                        // handle error
                    }
                }
            }
        }
    }
    
    func search() {
        self.searchResults = []

        let matches = self.rules.filter({
            $0.ruleNumber.lowercased().contains(self.searchText.lowercased()) ||
            $0.ruleText.lowercased().contains(self.searchText.lowercased())
        })
        
        let filteredMatches = matches.filter({
            $0.ruleNumber.rangeOfCharacter(from: letters) == nil
        })
        
        for (index, match) in filteredMatches.enumerated() {
            if (index <= 4) {
                self.searchResults.append(match)
            }
        }
    }
}
