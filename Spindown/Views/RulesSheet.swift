//
//  RulesSheet.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/3/23.
//

import Foundation
import SwiftUI

struct SearchDialog: View {
    @Binding var open: Bool

    @FocusState private var focused: FocusField?
    @State private var searchQuery: String = ""

    var screenWidth = UIScreen.main.bounds.width

    var body: some View {
        Dialog(content: {
            HStack {
                TextField("", text: $searchQuery)
                    .placeholder(when: searchQuery.isEmpty) {
                        Text("Search...").foregroundColor(Color(UIColor(named: "AccentGrayDarker")!))
                            .font(.system(size: 20, weight: .bold))
                    }
                    .keyboardType(.default)
                    .font(.system(size: 20, weight: .black))
                    .focused($focused, equals: .search)
            }
            .padding()
            .background(Color(UIColor(named: "DeepGray")!))
            .cornerRadius(4)
            .padding(4)
            .background(Color(UIColor(named: "DeepGray")!))
            .cornerRadius(6)
            .padding(4)
            .background(
                Color(UIColor(named: "AccentGrayDarker")!)
            )
            .cornerRadius(8)
            .onAppear {
                self.focused = .search
            }
        }, maxWidth: screenWidth - 100, open: $open, placement: .top)
    }
}

struct RulesSheet: View {
    @State private var isFetchingRules: Bool = false

    @State private var rules: [Rule] = []
    @State private var currentPage: Int = 1
    
    let letters = NSCharacterSet.letters
    
    @State private var showSearchDialog: Bool = false
    @State private var spinning: Bool = false

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
                    .padding([.top, .bottom])
                }
                .padding([.top, .bottom], -16)
                .padding([.leading, .trailing])
                
                if (self.spinning) {
                    Spinner()
                }
                
                Divider()
                    .frame(height: 4)
                    .background(Color(UIColor(named: "AccentGrayDarker")!))
                    .overlay(LinearGradient(colors: [.white.opacity(0.1), .clear], startPoint: .top, endPoint: .bottom))
                    .offset(y: 8)
                
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
                .padding([.leading, .trailing, .top])
                .background(Color(UIColor(named: "NotAsDeepGray")!).opacity(0.75))
            }
            
            SearchDialog(open: $showSearchDialog)
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
    }
    
    func getRules() {
        self.spinning = true
        self.rules = []

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
                    
                    self.spinning = false
                }
            } catch {
               // handle error
            }
        }
    }
}

struct RulesSheet_Previews: PreviewProvider {
    @State private static var showRulesSheet: Bool = true
    static var previews: some View {
        VStack {
            Text("Hello, World")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        .sheet(isPresented: $showRulesSheet) {
            RulesSheet().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .background(.black)
        }
    }
}
