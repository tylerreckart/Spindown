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
                
                StyledTextField(placeholderText: "Quantity...",  text: $lifeTotal, field: .quantity, focusOnAppear: true)
                
                HStack(spacing: 20) {
                    UIButtonOutlined(
                        text: "Add",
                        symbol: "plus",
                        fill: UIColor(named: "DeepGray")!,
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
                        fill: UIColor(named: "DeepGray")!,
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
