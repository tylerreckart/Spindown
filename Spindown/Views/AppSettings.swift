//
//  AppSettings.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/15/23.
//

import SwiftUI
import StoreKit

struct AppSettingsView: View {
    var dismissModal: () -> ()

    @Binding var showManageSubscriptions: Bool

    @State private var showPrivacyWebView: Bool = false
    @State private var showTermsWebView: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                List {
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
                            self.showTermsWebView.toggle()
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
                            self.showPrivacyWebView.toggle()
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
                                        .frame(width: 18, height: 14.73)
                                }
                                Text("Haptic Software")
                            }
                            .padding([.top, .bottom], 2)
                        }
                    }
                    .listRowBackground(Color(UIColor(named:"NotAsDeepGray")!))
                }
                .frame(height: 225)
                .background(Color(UIColor(named: "DeepGray")!))
                .scrollContentBackground(.hidden)
                .scrollDisabled(true)
                
                Text("© 2025 Haptic Software LLC. Spindown \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")")
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
            .sheet(isPresented: $showTermsWebView) {
                WebView(url: URL(string: "https://haptic.software/terms.html")!)
            }
            .sheet(isPresented: $showPrivacyWebView) {
                WebView(url: URL(string: "https://haptic.software/privacy.html")!)
            }
        }
    }
}
