//
//  FormatSelector.swift
//  Spindown
//
//  Created by Tyler Reckart on 1/29/23.
//

import SwiftUI

struct FormatSelector: View {
    @Binding var setupStep: Int

    var setFormat: (Format) -> ()

    var body: some View {
        VStack {
            Spacer()

            VStack {
                Text("Format")
                    .font(.system(size: 64, weight: .black))
                    .foregroundColor(.white)
                Text("Select a format or create your own.")
                    .font(.system(size: 20))
                    .foregroundColor(Color(.systemGray))
            }
            .padding(.bottom)

            VStack(spacing: 20) {
                UIButton(text: "Commander", symbol: nil, color: UIColor(named: "AccentGrayDarker")!, action: {
                    setFormat(Format(name: "Commander", startingLifeTotal: 40))
                    setupStep += 1
                })
                UIButton(text: "Standard", symbol: nil, color: UIColor(named: "AccentGrayDarker")!, action: {
                    setFormat(Format(name: "Standard", startingLifeTotal: 20))
                    setupStep += 1
                })
                UIButton(text: "Legacy", symbol: nil, color: UIColor(named: "AccentGrayDarker")!, action: {
                    setFormat(Format(name: "Legacy", startingLifeTotal: 40))
                    setupStep += 1
                })
                UIButtonOutlined(text: "Custom Format", symbol: nil, fill: .black, color: UIColor(named: "AccentGray")!, action: {
                    setupStep += 1
                })
            }
            .frame(maxWidth: 300)
            
            Spacer()
        }
    }
}
