//
//  SettingsDialog.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/14/23.
//

import SwiftUI

struct AppSettingsDialog: View {
    var store: Store
    
    @Binding var open: Bool
    
    @State private var dialogOpacity: CGFloat = 0
    @State private var dialogOffset: CGFloat = 0

    var body: some View {
        ScrollView {
            HStack(spacing: 0) {
                Image(systemName: "gearshape")
                    .padding(.trailing, 4)
                Text("Settings")
                Spacer()
                Button(action: { dismissModal() }) {
                    Image(systemName: "xmark.circle.fill")
                }
            }
            .font(.system(size: 24, weight: .black))
            .foregroundColor(Color.white)
            .padding()
            
            List {
                Section(header: Text("General")) {
                    NavigationLink(destination: EmptyView()) {
                        Text("Display")
                    }
                    NavigationLink(destination: EmptyView()) {
                        Text("Game History")
                    }
                    NavigationLink(destination: EmptyView()) {
                        Text("Players")
                    }
                    NavigationLink(destination: EmptyView()) {
                        Text("App Icon")
                    }
                }
                .listRowBackground(Color(UIColor(named: "NotAsDeepGray")!))
                .listRowSeparatorTint(Color.white.opacity(0.15))

                Section(header: Text("About")) {
                    NavigationLink(destination: EmptyView()) {
                        Text("Manage Subscription")
                    }
                    NavigationLink(destination: EmptyView()) {
                        Text("Terms of Use")
                    }
                    NavigationLink(destination: EmptyView()) {
                        Text("Privacy Policy")
                    }
                    NavigationLink(destination: EmptyView()) {
                        Text("Haptic Software")
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
        .padding()
        .background(Color(UIColor(named: "DeepGray")!))
        .frame(maxWidth: 500, maxHeight: 500)
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
