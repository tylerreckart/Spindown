//
//  About.swift
//  Spindown
//
//  Created by Tyler Reckart on 3/8/23.
//

import Foundation
import SwiftUI
import StoreKit

struct AboutView: View {
    @State private var showHapticSheet: Bool = false
    @State private var showSpindownSheet: Bool = false
    @State private var showDeveloperSheet: Bool = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image("SpindownIcon")
                    .resizable()
                    .frame(maxWidth: 100, maxHeight: 100)
                    .padding(.top, 75)
                Text("Hi, I'm Tyler. I run Haptic, the development studio behind Spindown, as a one-person shop without employees or outside funding.\n\nThis app would not be possible without the love and support of my family and our two dogs.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                List {
                    Section(header:
                        Text("Follow Us")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(UIColor(named: "AccentGray")!))
                    ) {
                        Button(action: {
                            self.showHapticSheet.toggle()
                        }) {
                            HStack(alignment: .center) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color(UIColor(named: "AlmostBlack")!))
                                        .frame(width: 30, height: 30)
                                    Image("HapticLogo")
                                        .resizable()
                                        .frame(width: 18, height: 18)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("Haptic")
                                    Text("Company News and Updates")
                                        .font(.caption)
                                }
                            }
                            .frame(height: 40)
                        }
                        
                                
                        Button(action: {
                            self.showSpindownSheet.toggle()
                        }) {
                            HStack(alignment: .center) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color(UIColor(named: "PrimaryRed")!))
                                        .frame(width: 30, height: 30)
                                    Image("SpindownIcon")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("Spindown")
                                    Text("App Updates and Feedback")
                                        .font(.caption)
                                }
                            }
                            .frame(height: 40)
                        }
                    
                        Button(action: {
                            self.showDeveloperSheet.toggle()
                        }) {
                            HStack(alignment: .center) {
                                Image("ProfilePhoto")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .cornerRadius(15)

                                VStack(alignment: .leading) {
                                    Text("Tyler Reckart")
                                    Text("Developer")
                                        .font(.caption)
                                }
                            }
                            .frame(height: 40)
                        }
                    }
                    .listRowBackground(Color(UIColor(named:"NotAsDeepGray")!))
                    
                    Section {
                        Button(action: {
                            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                                SKStoreReviewController.requestReview(in: scene)
                            }
                        }) {
                            Text("Rate Spindown on the App Store")
                        }
                    }
                    .listRowBackground(Color(UIColor(named:"NotAsDeepGray")!))
                }
                .frame(height: 350)
                .background(Color(UIColor(named: "DeepGray")!))
                .scrollContentBackground(.hidden)
                .scrollDisabled(true)
                .foregroundColor(.white)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .background(Color(UIColor(named: "DeepGray")!))
        .sheet(isPresented: $showHapticSheet) {
            WebView(url: URL(string: "https://mastodon.social/@haptic")!)
        }
        .sheet(isPresented: $showSpindownSheet) {
            WebView(url: URL(string: "https://mastodon.social/@spindown")!)
        }
        .sheet(isPresented: $showDeveloperSheet) {
            WebView(url: URL(string: "https://mastodon.social/@tyler")!)
        }
    }
}
