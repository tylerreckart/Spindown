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
}

struct LifeTotalCalculatorDialog: View {
    var toggleCalculator: () -> ()

    @State private var dialogOpacity: Double = 0
    @State private var dialogOffset: Double = 0
    
    @State private var lifeTotal: String = ""
    @FocusState private var focused: FocusField?
    @State private var activeSelection: LifeTotalCalculatorSelection = .subtract

    var body: some View {
        ZStack {
            Color.black.opacity(dialogOpacity - 0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    dismissModal()
                }

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
                    UIButton(
                        text: "Add",
                        symbol: "plus",
                        color:
                            self.activeSelection == .add ?
                        UIColor(named: "PrimaryPurple")! :
                            UIColor(named: "AccentGrayDarker")!,
                        action: {
                            self.activeSelection = .add
                        }
                    )
                    UIButton(
                        text: "Subtract",
                        symbol: "minus",
                        color:
                            self.activeSelection == .subtract ?
                        UIColor(named: "PrimaryPurple")! :
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
                            dismissModal()
                        }
                    )
                    .disabled(Int(lifeTotal) == nil)
                    .opacity(Int(lifeTotal) != nil ? 1 : 0.75)
                    
                    UIButtonOutlined(
                        text: "Cancel",
                        symbol: "xmark",
                        fill: .black,
                        color: UIColor(named: "AccentGray") ?? .systemGray, action: {
                            dismissModal()
                        }
                    )
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: 300)
            .padding(30)
            .background(
                Color(.black)
                    .overlay(LinearGradient(colors: [.white.opacity(0.05), .clear], startPoint: .top, endPoint: .bottom))
            )
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 15)
            .opacity(dialogOpacity)
            .scaleEffect(dialogOffset)
            .onAppear {
                
                withAnimation {
                    self.dialogOpacity = 1
                    self.dialogOffset = 1.1
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.focused = .quantity
                        withAnimation {
                            self.dialogOffset = 1
                        }
                    }
                }
            }
        }
    }
    
    func dismissModal() {
        withAnimation {
            self.dialogOpacity = 0
            self.dialogOffset = 0.75
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            toggleCalculator()
        }
    }
}

struct LifeTotalCalculatorDialog_Previews: PreviewProvider {
    static func toggleCalculator() {}
    static var previews: some View {
        LifeTotalCalculatorDialog(
            toggleCalculator: toggleCalculator
        ).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
