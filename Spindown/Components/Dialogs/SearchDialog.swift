//
//  SearchDialog.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/27/23.
//

import SwiftUI

struct SearchDialogContent: View {
    @Binding var searchText: String
    @Binding var results: [Rule]
    @Binding var selectedRule: Rule?
    @FocusState private var focused: FocusField?

    var body: some View {
        VStack(spacing: 20) {
            StyledTextField(placeholderText: "Search", text: $searchText, field: .search, focusOnAppear: true, fontSize: 20)
            
            if (self.searchText.count > 0) {
                Text("Showing results for \(self.searchText)...")
                    .font(.system(size: 14))
                    .italic()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color(UIColor(named: "AccentGrayDarker")!))
            }
            
            if (self.searchText.count > 0 && self.results.count == 0) {
                Text("No results found for \(self.searchText)")
                    .font(.system(size: 12))
                    .italic()
                    .foregroundColor(Color(UIColor(named: "AccentGray")!))
            }
            
            if (self.results.count > 0) {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(self.results, id: \.self) { result in
                        Button(action: {
                            withAnimation {
                                self.selectedRule = result
                            }
                        }) {
                            VStack(alignment: .leading) {
                                Text("(\(result.ruleNumber))")
                                    .font(.system(size: 14, weight: .bold))
                                HStack {
                                    Text("\(String(result.ruleText.prefix(80)))...")
                                        .italic()
                                        .foregroundColor(Color(UIColor(named: "AccentGray")!))
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                            }
                        }
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

struct SearchDialog: View {
    @Binding var open: Bool
    @Binding var searchText: String
    @Binding var results: [Rule]
    @Binding var selectedRule: Rule?
    var subrules: [Rule]

    var body: some View {
        Dialog(content: {
            switch (selectedRule) {
                case nil:
                    SearchDialogContent(searchText: $searchText, results: $results, selectedRule: $selectedRule)
                default:
                    RuleContext(selectedRule: $selectedRule, subrules: subrules)
            }
        },
           maxWidth: UIDevice.current.userInterfaceIdiom == .phone ? UIScreen.main.bounds.width - 100 : 500,
           open: $open,
           placement: .top
        )
    }
}
