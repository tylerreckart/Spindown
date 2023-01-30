//
//  FormatSelector.swift
//  Spindown
//
//  Created by Tyler Reckart on 1/29/23.
//

import SwiftUI

struct Format: Hashable {
    public static func == (lhs: Format, rhs: Format) -> Bool {
        return lhs.name == rhs.name
    }

    var name: String
    var startingLifeTotal: Int16
}

struct FormatSelector: View {
    @Binding var setupStep: Int

    var setFormat: (Format) -> ()

    var body: some View {
        ZStack {
            Color.black.opacity(0.2)
            
            VStack {
                VStack {
                    Text("Format")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                    Text("Choose a format or create your own")
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(Color(.systemGray))
                }

                HStack {
                    Button(action: {
                        setFormat(Format(name: "Commander", startingLifeTotal: 40))
                        setupStep += 1
                    }) {
                        MenuOption(text: "Commander", background: .systemGray5)
                    }
                    Button(action: {
                        setFormat(Format(name: "Standard", startingLifeTotal: 20))
                        setupStep += 1
                    }) {
                        MenuOption(text: "Standard", background: .systemGray5)
                    }
                    Button(action: {
                        setFormat(Format(name: "Modern", startingLifeTotal: 20))
                        setupStep += 1
                    }) {
                        MenuOption(text: "Modern", background: .systemGray5)
                    }
                }
                
                HStack {
                    Button(action: {
                        setFormat(Format(name: "Legacy", startingLifeTotal: 20))
                        setupStep += 1
                    }) {
                        MenuOption(text: "Legacy", background: .systemGray5)
                    }
                    Button(action: {
                        setFormat(Format(name: "Pioneer", startingLifeTotal: 20))
                        setupStep += 1
                    }) {
                        MenuOption(text: "Pioneer", background: .systemGray5)
                    }
                    Button(action: {
                        setFormat(Format(name: "Draft", startingLifeTotal: 20))
                        setupStep += 1
                    }) {
                        MenuOption(text: "Draft", background: .systemGray5)
                    }
                }
                
                MenuOptionOutlined(text: "Custom Format")
            }
            .frame(maxWidth: 600)
            .padding()
            .cornerRadius(18)
            .shadow(color: Color.black.opacity(0.1), radius: 20)
        }
        .edgesIgnoringSafeArea(.all)
    }
}
