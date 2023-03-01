//
//  AppSettings.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/15/23.
//

import SwiftUI
import StoreKit

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image("SpindownIcon")
                    .resizable()
                    .frame(maxWidth: 100, maxHeight: 100)
                    .padding(.top, 75)
                Text("Hi, I'm Tyler. I run Haptic Software as a one-man development studio without employees or outside funding.\n\nThis app would not be possible without the love and support of my wife, son, and our two dogs.")
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)
                
                List {
                    Section(header: Text("Follow Us")) {
                        Button(action: {
                            if let url = URL(string: "https://mastodon.social/@haptic") {
                                UIApplication.shared.open(url)
                            }
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
                            if let url = URL(string: "https://mastodon.social/@spindown") {
                                UIApplication.shared.open(url)
                            }
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
                            if let url = URL(string: "https://mastodon.social/@tyler") {
                                UIApplication.shared.open(url)
                            }
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
    }
}

struct AppSettingsView: View {
    var dismissModal: () -> ()

    @Binding var showManageSubscriptions: Bool

    var body: some View {
        NavigationStack {
            ScrollView {
                List {
                    Section(header: Text("General")) {
                        NavigationLink(destination: EmptyView()) {
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(UIColor(named: "PrimaryRed")!))
                                        .frame(width: 30, height: 30)
                                        .shadow(color: Color.black.opacity(0.1), radius: 3)
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.white)
                                        .shadow(color: Color.black.opacity(0.1), radius: 3)
                                }
                                Text("Players")
                            }
                            .padding([.top, .bottom], 2)
                        }
                        NavigationLink(destination: EmptyView()) {
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(UIColor(named: "AccentGrayDarker")!))
                                        .frame(width: 30, height: 30)
                                        .shadow(color: Color.black.opacity(0.1), radius: 3)
                                    
                                    VStack(spacing: 4) {
                                        HStack(spacing: 4) {
                                            RoundedRectangle(cornerRadius: 2)
                                                .fill(Color(UIColor(named: "AccentGray")!))
                                                .frame(width: 8, height: 8)
                                                .shadow(color: Color.black.opacity(0.05), radius: 1)
                                            RoundedRectangle(cornerRadius: 2)
                                                .fill(Color(UIColor(named: "AccentGray")!))
                                                .frame(width: 8, height: 8)
                                                .shadow(color: Color.black.opacity(0.05), radius: 1)
                                        }
                                        HStack(spacing: 4) {
                                            RoundedRectangle(cornerRadius: 2)
                                                .fill(Color(UIColor(named: "PrimaryBlue")!))
                                                .frame(width: 8, height: 8)
                                                .shadow(color: Color.black.opacity(0.1), radius: 1)
                                            RoundedRectangle(cornerRadius: 2)
                                                .fill(Color(UIColor(named: "AccentGray")!))
                                                .frame(width: 8, height: 8)
                                                .shadow(color: Color.black.opacity(0.05), radius: 1)
                                        }
                                    }
                                }
                                Text("App Icon")
                            }
                            .padding([.top, .bottom], 2)
                        }
                    }
                    .listRowBackground(Color(UIColor(named:"NotAsDeepGray")!))
                    .listRowSeparatorTint(Color.white.opacity(0.15))
                    
                    Section(header: Text("About")) {
                        Button(action: { self.showManageSubscriptions.toggle() }) {
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(UIColor(named: "PrimaryPurple")!))
                                        .frame(width: 30, height: 30)
                                        .shadow(color: Color.black.opacity(0.1), radius: 3)
                                    Image(systemName: "creditcard.fill")
                                        .foregroundColor(.white)
                                        .shadow(color: Color.black.opacity(0.1), radius: 3)
                                }
                                Text("Manage Subscription")
                                    .foregroundColor(.white)
                            }
                            .padding([.top, .bottom], 2)
                        }
                        Button(action: {
                            if let url = URL(string: "https://haptic.software/terms") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(UIColor(named: "AccentGray")!))
                                        .frame(width: 30, height: 30)
                                        .shadow(color: Color.black.opacity(0.1), radius: 3)
                                    Image(systemName: "doc.plaintext.fill")
                                        .foregroundColor(.white)
                                        .shadow(color: Color.black.opacity(0.1), radius: 3)
                                }
                                Text("Terms Of Use")
                            }
                            .padding([.top, .bottom], 2)
                        }
                        Button(action: {
                            if let url = URL(string: "https://haptic.software/privacy") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(UIColor(named: "AccentGray")!))
                                        .frame(width: 30, height: 30)
                                        .shadow(color: Color.black.opacity(0.1), radius: 3)
                                    Image(systemName: "lock.fill")
                                        .foregroundColor(.white)
                                        .shadow(color: Color.black.opacity(0.1), radius: 3)
                                }
                                Text("Privacy Policy")
                            }
                            .padding([.top, .bottom], 2)
                        }
                        NavigationLink(destination: AboutView()) {
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(UIColor(named: "AlmostBlack")!))
                                        .frame(width: 30, height: 30)
                                    Image("HapticLogo")
                                        .resizable()
                                        .frame(width: 18, height: 18)
                                }
                                Text("Haptic Software")
                            }
                            .padding([.top, .bottom], 2)
                        }
                    }
                    .listRowBackground(Color(UIColor(named:"NotAsDeepGray")!))
                }
                .frame(height: 375)
                .background(Color(UIColor(named: "DeepGray")!))
                .scrollContentBackground(.hidden)
                .scrollDisabled(true)
                
                Text("© 2023 Haptic Software LLC. Spindown \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")")
                    .font(.system(size: 12))
                    .foregroundColor(Color(UIColor(named: "AccentGray")!))
                    .padding(.bottom)
            }
            .foregroundColor(.white)
            .background(Color(UIColor(named: "DeepGray")!))
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismissModal()
                    }) {
                        Text("Close")
                            .foregroundColor(Color(UIColor(named: "PrimaryRed")!))
                    }
                }
            }
        }
    }
}
