//
//  RulesSheet.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/3/23.
//

import Foundation
import SwiftUI

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }

            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }

            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return width
                }
            }

            var h: CGFloat {
                switch edge {
                case .top, .bottom: return width
                case .leading, .trailing: return rect.height
                }
            }
            path.addRect(CGRect(x: x, y: y, width: w, height: h))
        }
        return path
    }
}

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

struct SubruleContainer: View {
    var subrules: [Rule]
    
    @State private var isOpen: Bool = false

    var body: some View {
        if (subrules.count > 0) {
            VStack {
                Button(action: {
                    withAnimation {
                        self.isOpen.toggle()
                    }
                }) {
                    HStack {
                        Text("Subrules")
                            .font(.system(size: 16, weight: .black))
                            .multilineTextAlignment(.leading)
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .black))
                            .multilineTextAlignment(.leading)
                            .rotationEffect(Angle(degrees: self.isOpen ? 90 : 0))
                        
                        Spacer()
                    }
                    .padding(.bottom, self.isOpen ? 5 : 0)
                }
                
                if (self.isOpen) {
                    VStack(spacing: 20) {
                        ForEach(subrules.sorted { $0.ruleNumber < $1.ruleNumber }, id: \.self) { subrule in
                            VStack {
                                HStack {
                                    Text(subrule.ruleNumber)
                                        .font(.system(size: 18, weight: .black))
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                                
                                HStack {
                                    Text(subrule.ruleText)
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                                
                                ExamplesContainer(examples: subrule.examples ?? [])
                                    .padding(.top, 10)
                            }
                        }
                        .transition(.opacity)
                        .padding(.leading, 20)
                    }
                    .border(width: 4, edges: [.leading], color: Color(UIColor(named: "NotAsDeepGray")!))
                }
            }
        }
    }
}

struct ExamplesContainer: View {
    var examples: [String?]
    
    @State private var isOpen: Bool = false

    var body: some View {
        if (examples.count > 0) {
            VStack {
                Button(action: {
                    withAnimation {
                        self.isOpen.toggle()
                    }
                }) {
                    HStack {
                        Text("Examples")
                            .font(.system(size: 16, weight: .black))
                            .multilineTextAlignment(.leading)
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .black))
                            .multilineTextAlignment(.leading)
                            .rotationEffect(Angle(degrees: self.isOpen ? 90 : 0))
                        
                        Spacer()
                    }
                    .padding(.bottom, self.isOpen ? 5 : 0)
                }
                
                if (self.isOpen) {
                    VStack(spacing: 20) {
                        ForEach(examples, id: \.self) { example in
                            HStack {
                                Text(example!)
                                    .foregroundColor(Color(UIColor(named: "AccentGray")!))
                                    .italic()
                                Spacer()
                            }
                        }
                        .transition(.opacity)
                        .padding(.leading, 20)
                    }
                    .border(width: 4, edges: [.leading], color: Color(UIColor(named: "NotAsDeepGray")!))
                }
            }
        }
    }
}

struct RuleBody: View {
    var rule: Rule
    var subrules: [Rule]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(rule.ruleNumber)
                .font(.system(size: 18, weight: .black))
                .multilineTextAlignment(.leading)
            HStack {
                Text(rule.ruleText)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            
            ExamplesContainer(examples: rule.examples ?? [])
                .padding(.top, 10)
            SubruleContainer(subrules: subrules.filter({ $0.ruleNumber.contains(rule.ruleNumber) }))
                .padding(.top, 10)
        }
        .frame(maxWidth: .infinity)
    }
}

struct RulesSheet: View {
    @State private var isFetchingRules: Bool = true

    @State private var rules: [Rule] = []
    @State private var subrules: [Rule] = []
    
    let letters = NSCharacterSet.letters
    
    @State private var showSearchDialog: Bool = false
    @State private var searchText: String = ""
    @State private var searchResults: [Rule] = []
    @State private var selectedRule: Rule?
    @State private var selectedRuleSubrules: [Rule] = []
    
    var dict: [String: String] = [
        "100": "Game Concepts",
        "200": "Parts of a Card",
        "300": "Card Types",
        "400": "Zones",
        "500": "Turn Structure",
        "600": "Spells, Abilities, and Effects",
        "700": "Additional Rules",
        "800": "Multiplayer Rules",
        "900": "Casual Variants"
    ]
    
    @State private var currentPage: String = "100"

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
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
                    .overlay(LinearGradient(colors: [.white.opacity(0.05), .clear], startPoint: .top, endPoint: .bottom))

                ZStack {
                    if (self.isFetchingRules) {
                        VStack {
                            Spacer()
                            Spinner()
                            Spacer()
                        }
                    } else {
                        VStack {
                            ScrollView {
                                let entry = dict.first(where: { (key, _) in key.contains(self.currentPage) })
                                
                                HStack {
                                    Text(entry!.value)
                                        .font(.system(size: 28, weight: .black))
                                        .padding([.top, .leading, .trailing])
                                        .padding(.bottom, -10)
                                    Spacer()
                                }

                                VStack(spacing: 20) {
                                    ForEach(
                                        rules
                                            .filter({ $0.ruleNumber.prefix(1) == self.currentPage.prefix(1) })
                                            .sorted { $0.ruleNumber < $1.ruleNumber },
                                        id: \.self
                                    ) { rule in
                                        RuleBody(rule: rule, subrules: subrules)
                                    }
                                }
                                .padding()
                            }
                            .padding(.bottom, 55)
                            .transition(.push(from: .bottom))
                        }
                        
                        VStack(spacing: 0) {
                            Spacer()
                            Divider()
                                .frame(height: 4)
                                .background(Color(UIColor(named: "AccentGrayDarker")!))
                                .overlay(LinearGradient(colors: [.white.opacity(0.05), .clear], startPoint: .top, endPoint: .bottom))
                            
                            HStack {
                                let keys = Array(dict.keys).sorted()
                                let currentIndex = keys.firstIndex(where: { $0 == self.currentPage })
                                let nextIndex = (currentIndex ?? 0) + 1
                                let prevIndex = (currentIndex ?? 0) - 1
                                
                                Button(action: {
                                    if (prevIndex > -1) {
                                        self.currentPage = keys[prevIndex]
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: "chevron.left")
                                        Text("Prev")
                                    }
                                    .font(.system(size: 16, weight: .black))
                                }
                                .disabled(currentIndex == 0)
                                .foregroundColor(prevIndex > -1 ? .white : Color(UIColor(named: "AccentGrayDarker")!))
                                
                                
                                Spacer()
                                
                                Button(action: {
                                    if (nextIndex <= keys.count) {
                                        self.currentPage = keys[nextIndex]
                                    }
                                }) {
                                    HStack {
                                        Text("Next")
                                        Image(systemName: "chevron.right")
                                    }
                                    .font(.system(size: 16, weight: .black))
                                }
                                .disabled(nextIndex == keys.count)
                                .foregroundColor(currentIndex != keys.count - 1 ? .white : Color(UIColor(named: "AccentGrayDarker")!))
                            }
                            .padding()
                            .background(Color(UIColor(named: "NotAsDeepGray")!).opacity(0.75))
                        }
                    }
                }
            }
            
            SearchDialog(
                open: $showSearchDialog,
                searchText: $searchText,
                results: $searchResults,
                selectedRule: $selectedRule,
                subrules: subrules.filter({ $0.ruleNumber.contains(self.selectedRule?.ruleNumber ?? "") })
            )
        }
        .foregroundColor(Color.white)
        .background(Color(UIColor(named: "DeepGray")!))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task {
            if (self.rules == []) {
                await getRules()
            }
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
    
    func mapRuleResponseToModel(_ rule: AnyObject) -> Rule {
        let obj = Rule()
        obj.ruleNumber = (rule["ruleNumber"] as? String)!
        obj.examples = rule["examples"] as? [String?]
        obj.ruleText = (rule["ruleText"] as? String)!
        obj.fragment = rule["fragment"] as? String
        obj.navigation = rule["navigation"] as? RulesNavigation
        return obj
    }
    
    func fetchRulesetForPage(page: Int) async {
        if let path = Bundle.main.path(forResource: "\(page)00", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                    for (_, rule) in jsonResult {
                        let data = mapRuleResponseToModel(rule)

                        Task.detached(priority: .background) {
                            if (data.ruleNumber.rangeOfCharacter(from: letters) == nil) {
                                self.rules.append(data)
                            } else {
                                self.subrules.append(data)
                            }
                        }
                    }
                }
            } catch {
                // handle error
            }
        }
    }
    
    func getRules() async {
        withAnimation {
            self.isFetchingRules = true
        }

        Task.detached(priority: .background) {
            for page in 1...9 {
                await fetchRulesetForPage(page: page)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    self.isFetchingRules = false
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
