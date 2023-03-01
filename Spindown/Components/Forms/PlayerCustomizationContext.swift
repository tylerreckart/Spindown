//
//  PlayerCustomizationContext.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/27/23.
//

import SwiftUI

struct PlayerCustomizationContext: View {
    @State private var name: String = ""
    @State private var selectedColor: UIColor = UIColor(named: "PrimaryPurple")!
    
    var customize: Bool = false

    var savePlayer: (_ name: String, _ color: UIColor) -> Void
    var dismiss: () -> Void
    var delete: (_ player: Participant) -> Void = { player in
        return
    }
    
    var selectedPlayer: Participant? = nil
    
    @State private var showDeletePlayerAlert: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 0) {
                Image(systemName: "person")
                    .foregroundColor(Color.white)
                    .font(.system(size: 24, weight: .black))
                    .padding(.trailing, 4)
                Text(self.customize ? "Edit Player" : "Add New Player")
                    .font(.system(size: 24, weight: .black))
                    .foregroundColor(Color.white)
                Spacer()
            }

            StyledTextField(placeholderText: "Player Name...",  text: $name, field: .name, focusOnAppear: true)
            
            Text("Select A Color")
                .font(.system(size: 16))
                .foregroundColor(Color(UIColor(named: "AccentGray")!))
            
            HStack {
                ForEach(colors, id: \.self) { color in
                    HStack {
                        Button(action: {
                            withAnimation {
                                self.selectedColor = color
                            }
                        }) {
                            Circle()
                                .fill(Color(color))
                                .frame(width: 30, height: 30)
                                .padding(4)
                                .background(self.selectedColor == color ? .white : .clear)
                                .cornerRadius(.infinity)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            
            VStack(spacing: 20) {
                UIButton(
                    text: "Save Player",
                    color: (self.name.count != 0 ? UIColor(named: "PrimaryRed")! : UIColor(named: "AccentGrayDarker"))!,
                    action: {
                        savePlayer(self.name, self.selectedColor)
                    }
                )
                .opacity(self.name.count != 0 ? 1 : 0.5)
                
                if (self.customize) {
                    UIButtonOutlined(
                        text: "Delete Player",
                        fill: UIColor(named: "DeepGray")!,
                        color: UIColor(named: "AccentGray")!,
                        action: {
                            self.showDeletePlayerAlert.toggle()
                        }
                    )
                }
                
                UIButtonOutlined(
                    text: "Cancel",
                    fill: UIColor(named: "DeepGray")!,
                    color: UIColor(named: "AccentGray")!,
                    action: dismiss
                )
                
            }
        }
        .onAppear {
            if (self.customize && self.selectedPlayer != nil) {
                self.name = self.selectedPlayer!.name
                self.selectedColor = self.selectedPlayer!.color
            }
        }
        .alert(isPresented: $showDeletePlayerAlert) {
            Alert(title: Text("Delete Player"),
                  message: Text("Are you sure you want to delete this player? This action cannot be undone."),
                  primaryButton: .default(Text("Cancel")),
                  secondaryButton: .destructive(
                      Text("Delete"),
                      action: {
                          delete(selectedPlayer!)
                          dismiss()
                      }
                  )
            )
        }
    }
}
