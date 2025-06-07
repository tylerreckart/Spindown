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
                VStack {
                    Section {
                        Button(action: { self.showManageSubscriptions.toggle() }) {
                            HStack {
                                ZStack {
                                    Rectangle().fill(Color(.systemBlue)).frame(width: 32, height: 32).cornerRadius(10)
                                    Image(systemName: "creditcard.fill")
                                        .foregroundColor(.white)
                                        .fontWeight(.semibold)
                                        .symbolRenderingMode(.hierarchical)
                                }
                                Text("Manage Subscription")
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding([.top, .bottom], 2)
                        }
                        Divider().padding(.vertical, 5)
                        Button(action: {
                            self.showTermsWebView.toggle()
                        }) {
                            HStack {
                                ZStack {
                                    Rectangle().fill(Color(.systemYellow)).frame(width: 32, height: 32).cornerRadius(10)
                                    Image(systemName: "richtext.page.fill")
                                        .foregroundColor(.white)
                                        .fontWeight(.semibold)
                                        .symbolRenderingMode(.hierarchical)
                                }
                                Link("Terms of Service", destination: URL(string: "https://www.haptic.software/terms.html")!)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                        }
                        Divider().padding(.vertical, 5)
                        Button(action: {
                            self.showPrivacyWebView.toggle()
                        }) {
                            HStack {
                                ZStack {
                                    Rectangle().fill(Color(.systemBlue)).frame(width: 32, height: 32).cornerRadius(10)
                                    Image(systemName: "richtext.page.fill")
                                        .foregroundColor(.white)
                                        .fontWeight(.semibold)
                                        .symbolRenderingMode(.hierarchical)
                                }
                                Link("Privacy Policy", destination: URL(string: "https://www.haptic.software/privacy.html")!)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                        }
                        Divider().padding(.vertical, 5)
                        NavigationLink(destination: AboutView()) {
                            HStack {
                                ZStack {
                                    Rectangle().fill(Color(.systemRed)).frame(width: 32, height: 32).cornerRadius(10)
                                    Image(systemName: "info.circle.fill")
                                        .foregroundColor(.white)
                                        .fontWeight(.semibold)
                                        .symbolRenderingMode(.hierarchical)
                                }
                                Text("About")
                                Spacer()
                            }
                        }
                    }
                    .listRowBackground(Color(UIColor(named:"NotAsDeepGray")!))
                }
                .foregroundColor(.white)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .padding(.horizontal)
                
                Text("© 2025 Haptic Software LLC. Spindown \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .padding(.vertical)
            }
            .foregroundColor(.white)
            .background(.black)
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
