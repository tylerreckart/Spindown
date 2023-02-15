//
//  LifeTotalCalculatorDialog.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/6/23.
//

import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

enum LifeTotalCalculatorSelection {
    case add
    case subtract
}

enum FocusField {
    case quantity
    case hours
    case minutes
    case seconds
}

struct LifeTotalCalculatorDialog: View {
    @Binding var open: Bool
    @Binding var selectedPlayer: Participant?
    var toggleCalculator: () -> ()
    var updateLifeTotal: (Participant, Int) -> Void
    @FocusState private var focused: FocusField?
    @State private var lifeTotal: String = ""
    @State private var activeSelection: LifeTotalCalculatorSelection = .subtract

    var body: some View {
        Dialog(content: {
            VStack(spacing: 20) {
                HStack(spacing: 0) {
                    Image(systemName: "heart")
                        .foregroundColor(Color.white)
                        .font(.system(size: 24, weight: .black))
                        .padding(.trailing, 4)
                    Text("Add/Subtract Life")
                        .font(.system(size: 24, weight: .black))
                        .foregroundColor(Color.white)
                    Spacer()
                }
                
                HStack {
                    TextField("", text: $lifeTotal)
                        .placeholder(when: lifeTotal.isEmpty) {
                            Text("Quantity...").foregroundColor(Color(UIColor(named: "AccentGrayDarker")!))
                                .font(.system(size: 28, weight: .bold))
                        }
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 28, weight: .black))
                        .focused($focused, equals: .quantity)
                }
                .padding()
                .background(Color(UIColor(named: "DeepGray")!))
                .cornerRadius(4)
                .padding(4)
                .background(.black)
                .cornerRadius(6)
                .padding(4)
                .background(
                    Color(UIColor(named: "AccentGrayDarker")!)
                )
                .cornerRadius(8)
                
                HStack(spacing: 20) {
                    UIButtonOutlined(
                        text: "Add",
                        symbol: "plus",
                        fill: .black,
                        color:
                            self.activeSelection == .add ?
                            .white :
                            UIColor(named: "AccentGrayDarker")!,
                        action: {
                            self.activeSelection = .add
                        }
                    )
                    UIButtonOutlined(
                        text: "Subtract",
                        symbol: "minus",
                        fill: .black,
                        color:
                            self.activeSelection == .subtract ?
                            .white :
                            UIColor(named: "AccentGrayDarker")!,
                        action: {
                            self.activeSelection = .subtract
                        }
                    )
                }
                
                HStack(spacing: 20) {
                    UIButton(
                        text: "Save",
                        symbol: "checkmark",
                        color: UIColor(named: "PrimaryRed")!,
                        action: {
                            let delta = Int(self.lifeTotal) ?? 0
                            let lifeTotal = self.selectedPlayer!.lifeTotal
        
                            if (self.activeSelection == .add) {
                                updateLifeTotal(self.selectedPlayer!, lifeTotal + delta)
                            } else {
                                updateLifeTotal(self.selectedPlayer!, lifeTotal - delta)
                            }

                            withAnimation(.easeInOut(duration: 0.4)) {
                                self.open.toggle()
                                // Reset local state.
                                self.lifeTotal = ""
                            }
                        }
                    )
                    .disabled(Int(lifeTotal) == nil)
                    .opacity(Int(lifeTotal) != nil ? 1 : 0.5)
                    
                    UIButton(
                        text: "Cancel",
                        symbol: "xmark",
                        color: UIColor(named: "AccentGrayDarker") ?? .systemGray, action: {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                self.open.toggle()
                            }
                        }
                    )
                }
            }
            .onAppear {
                self.focused = .quantity
            }
        }, maxWidth: 300, open: $open)
    }
}
