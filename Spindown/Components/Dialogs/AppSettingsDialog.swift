//
//  SettingsDialog.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/14/23.
//

import SwiftUI

struct AppSettingsView: View {
    var dismissModal: () -> ()

    @Binding var showManageSubscriptions: Bool

    var body: some View {
        ScrollView {
            List {
                Section(header: Text("General")) {
                    NavigationLink(destination: EmptyView()) {
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color(UIColor(named: "PrimaryRed")!))
                                    .frame(width: 30, height: 30)
                                    .shadow(color: Color.black.opacity(0.1), radius: 3)
                                Image(systemName: "textformat")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .bold))
                                    .shadow(color: Color.black.opacity(0.1), radius: 3)
                            }
                            Text("Display")
                        }
                        .padding([.top, .bottom], 2)
                    }
                    NavigationLink(destination: EmptyView()) {
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color(UIColor(named: "PrimaryBlue")!))
                                    .frame(width: 30, height: 30)
                                    .shadow(color: Color.black.opacity(0.1), radius: 3)
                                Image(systemName: "note.text")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .bold))
                                    .shadow(color: Color.black.opacity(0.1), radius: 3)
                            }
                            Text("Game History")
                        }
                        .padding([.top, .bottom], 2)
                    }
                    NavigationLink(destination: EmptyView()) {
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color(UIColor(named: "PrimaryPurple")!))
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
                                RoundedRectangle(cornerRadius: 6)
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
                                            .shadow(color: Color.black.opacity(0.2), radius: 1)
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
                .listRowBackground(Color(UIColor(named: "NotAsDeepGray")!))
                .listRowSeparatorTint(Color.white.opacity(0.15))
                
                Section(header: Text("About")) {
                    Button(action: { self.showManageSubscriptions.toggle() }) {
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 6)
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
                    NavigationLink(destination: TermsOfUseView()) {
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 6)
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
                    NavigationLink(destination: PrivacyPolicyView()) {
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 6)
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
                    NavigationLink(destination: EmptyView()) {
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color(.black))
                                    .frame(width: 30, height: 30)
                                    .shadow(color: Color.black.opacity(0.1), radius: 3)
                                Image(systemName: "creditcard.fill")
                                    .foregroundColor(.white)
                                    .shadow(color: Color.black.opacity(0.1), radius: 3)
                            }
                            Text("Haptic Software")
                        }
                        .padding([.top, .bottom], 2)
                    }
                }
                .listRowBackground(Color(UIColor(named: "NotAsDeepGray")!))
            }
            .frame(height: 460)
            .background(Color(UIColor(named: "DeepGray")!))
            .scrollContentBackground(.hidden)
            .scrollDisabled(true)
            
            Text("© 2023 Haptic Software LLC. Spindown 1.0.1")
                .font(.system(size: 12))
                .foregroundColor(Color(UIColor(named: "AccentGray")!))
                .padding(.bottom)
        }
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

struct AppSettingsDialog: View {
    var store: Store
    
    @Binding var open: Bool
    
    @State private var dialogOpacity: CGFloat = 0
    @State private var dialogOffset: CGFloat = 0
    
    @State private var showManageSubscriptions: Bool = false

    var body: some View {
        NavigationStack {
            AppSettingsView(dismissModal: dismissModal, showManageSubscriptions: $showManageSubscriptions)
        }
        .background(Color(UIColor(named: "DeepGray")!))
        .frame(maxWidth: 475, maxHeight: 475)
        .foregroundColor(.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 15)
        .opacity(dialogOpacity)
        .scaleEffect(dialogOffset)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6)) {
                self.dialogOpacity = 1
                self.dialogOffset = 1.1
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation {
                        self.dialogOffset = 1
                    }
                }
            }
        }
        .manageSubscriptionsSheet(isPresented: $showManageSubscriptions)
    }
    
    func dismissModal() {
        withAnimation {
            self.dialogOpacity = 0
            self.dialogOffset = 0.75
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.open.toggle()
        }
    }
}
