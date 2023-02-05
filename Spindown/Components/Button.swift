//
//  Button.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/1/23.
//

import SwiftUI

struct UIButton: View {
    var text: String
    var symbol: String?
    var color: UIColor
    var action: () -> ()

    var body: some View {
        Button(action: { action() }) {
            VStack(alignment: .center) {
                HStack(alignment: .center) {
                    if (symbol != nil) {
                        Image(systemName: symbol!)
                    }
                    Text(text)
                }
            }
            .font(.system(size: 16, weight: .black))
            .foregroundColor(Color(.white))
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 60)
            .background(
                Color(color)
                    .overlay(LinearGradient(colors: [.white.opacity(0.1), .clear], startPoint: .top, endPoint: .bottom))
            )
            .cornerRadius(8)
        }
    }
}

struct UIButtonTile: View {
    var text: String
    var symbol: String?
    var color: UIColor
    var action: () -> ()

    var body: some View {
        Button(action: { action() }) {
            VStack(alignment: .center) {
                HStack(alignment: .center) {
                    if (symbol != nil) {
                        Image(systemName: symbol!)
                    }
                    Text(text)
                }
            }
            .font(.system(size: 24, weight: .black))
            .foregroundColor(Color(.white))
            .padding()
            .frame(width: 100, height: 100)
            .background(Color(color).overlay(LinearGradient(colors: [.white.opacity(0.1), .clear], startPoint: .top, endPoint: .bottom)))
            .cornerRadius(8)
        }
    }
}

struct UIButtonOutlined: View {
    var text: String
    var symbol: String?
    var fill: UIColor
    var color: UIColor
    var action: () -> ()

    var body: some View {
        Button(action: { action() }) {
            VStack(alignment: .center) {
                HStack(alignment: .center) {
                    if (symbol != nil) {
                        Image(systemName: symbol!)
                            .shadow(color: Color.black.opacity(0.1), radius: 5)
                    }
                    Text(text)
                        .shadow(color: Color.black.opacity(0.1), radius: 5)
                }
            }
            .font(.system(size: 16, weight: .black))
            .foregroundColor(Color(.white))
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 60)
            .background(
                Color(color).opacity(0.4)
                    .overlay(LinearGradient(colors: [.white.opacity(0.1), .clear], startPoint: .top, endPoint: .bottom))
                    .overlay(Rectangle().fill(Color(fill)).frame(maxWidth: .infinity, maxHeight: .infinity).cornerRadius(4).padding(4)))
            .cornerRadius(8)
        }
    }
}

struct UIButtonStacked: View {
    var text: String
    var symbol: String?
    var color: UIColor
    var action: () -> ()

    var body: some View {
        Button(action: { action() }) {
            VStack(alignment: .center, spacing: 5) {
                if (symbol != nil) {
                    Image(systemName: symbol!)
                        .font(.system(size: 16, weight: .black))
                }
                Text(text)
                    .font(.system(size: 12, weight: .black))
            }
            .foregroundColor(Color(.white))
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(color).overlay(LinearGradient(colors: [.white.opacity(0.1), .clear], startPoint: .top, endPoint: .bottom)))
            .cornerRadius(8)
        }
    }
}
