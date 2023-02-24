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
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.leading)
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
        }, maxWidth: screenWidth - 100, open: $open)
    }
}

struct RulesSheet: View {
    @State private var isFetchingRules: Bool = false

    @State private var rules: [Rule] = []
    @State private var currentPage: Int = 1
    
    let letters = NSCharacterSet.letters
    
    @State private var showSearchDialog: Bool = false

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Rulebook")
                        .font(.system(size: 32, weight: .black))
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            self.showSearchDialog.toggle()
                        }
                    }) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            Text("Search for a rule")
                        }
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
            .padding()
            
            SearchDialog(open: $showSearchDialog)
        }
        .foregroundColor(Color.white)
        .background(Color(UIColor(named: "DeepGray")!))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            getRules()
        }
        .onChange(of: currentPage) { newState in
            getRules()
        }
    }
    
    func getRules() {
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
            .background(.black)
    }
}
