//
//  SubscriptionDialog.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/14/23.
//

import SwiftUI
import StoreKit

struct SubscriptionView: View {
    @Environment(\.presentationMode) var presentationMode

    var store: Store

    // Store data.
    @State private var selectedOffer: Product?
    @State private var isPurchasing: Bool = false
    @State private var hasPurchased: Bool = false
    // Sheet views.
    @State private var showManageSubscriptions: Bool = false
    // Error handling.
    @State private var errorMessage: String?
    @State private var showErrorAlert: Bool = false
    @State private var showNoSubscriptionAlert: Bool = false
    // Web views.
    @State private var showPrivacyWebView: Bool = false
    @State private var showTermsWebView: Bool = false
    
    var icon: UIImage? {
        guard let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? NSDictionary,
            let primaryIconsDictionary = iconsDictionary["CFBundlePrimaryIcon"] as? NSDictionary,
            let iconFiles = primaryIconsDictionary["CFBundleIconFiles"] as? NSArray,
            // First will be smallest for the device class, last will be the largest for device class
            let lastIcon = iconFiles.lastObject as? String,
            let icon = UIImage(named: lastIcon) else {
                return nil
        }

        return icon
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .center, spacing: 0) {
                    VStack(spacing: 0) {
                        Image(uiImage: icon!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 72)
                            .cornerRadius(18)
                    }
                    .padding(.top, 30)
                    .padding(.bottom)
                    
                    VStack {
                        HStack(alignment: .center) {
                            Text("Spindown")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.trailing, -5)
                            Image(systemName: "plus.app")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color(UIColor(named: "PrimaryBlue")!))
                        }
                        .padding(.bottom, 5)
                    }
                    .padding(.horizontal)
                    
                    
                    Pitch(store: store, selectedOffer: $selectedOffer)
                        .padding(.bottom, 20)
                    
                    VStack(spacing: 20) {
                        UIButton(text: "Subscribe", color: UIColor(named: "PrimaryRed")!, action: {
                            Task {
                                await buy()
                            }
                        })
                        
                        
                        UIButtonOutlined(text: "Restore Previous Purchases", fill: UIColor(named: "DeepGray")!, color: UIColor(named: "AccentGrayDarker")!, action: {
                            self.isPurchasing.toggle()
                            Task {
                                try? await AppStore.sync()
                                self.isPurchasing.toggle()
                                
                                if (store.purchasedSubscriptions.isEmpty) {
                                    self.showNoSubscriptionAlert.toggle()
                                }
                            }
                        })
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                VStack {
                    Text("Payment for your subscription will be charged to your Apple ID account at the confirmation of purchase. Subscription automatically renews unless cancelled at least 24 hours before the end of the current period. Your account will be charged for renewal within 24 hours prior to the end of the current period.")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.systemGray))
                        .padding(.horizontal)
                        .padding(.bottom, 5)
                        .fixedSize(horizontal: false, vertical: true)
                    Text("You can manage and cancel your subscriptions by got to your account settings in the App Store after purchase.")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.systemGray))
                        .padding(.horizontal)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal)
                
                VStack(spacing: 20) {
                    UIButtonOutlined(
                        text: "Terms of Use",
                        fill: UIColor(named: "DeepGray")!,
                        color: UIColor(named: "AccentGrayDarker")!,
                        action: {
                            self.showTermsWebView.toggle()
                        }
                    )
                    UIButtonOutlined(
                        text: "Privacy Policy",
                        fill: UIColor(named: "DeepGray")!,
                        color: UIColor(named: "AccentGrayDarker")!,
                        action: {
                            self.showPrivacyWebView.toggle()
                        }
                    )
                }
                .padding()
            }
            
            if (self.isPurchasing) {
                Color.black.opacity(0.2)
                    .edgesIgnoringSafeArea(.all)
                Spinner()
            }
        }
        .foregroundColor(.white)
        .background(Color(UIColor(named: "DeepGray")!))
        .interactiveDismissDisabled(true)
        .onChange(of: store.purchasedSubscriptions) { subscriptions in
            if (subscriptions.count > 0) {
                if (self.isPurchasing) {
                    self.isPurchasing.toggle()
                }
                presentationMode.wrappedValue.dismiss()
            }
        }
        .alert(isPresented: $showErrorAlert, error: ValidationError.NaN) {_ in
            Button(action: {
                showErrorAlert = false
            }) {
                Text("Ok")
            }
        } message: { error in
            Text(errorMessage ?? "Error. Please try again.")
        }
        .alert(isPresented: $showNoSubscriptionAlert, error: ValidationError.NaN) {_ in
            Button(action: {
                showNoSubscriptionAlert = false
            }) {
                Text("Ok")
            }
        } message: { error in
            Text("No subscription found. Please choose a plan or contact support.")
        }
        .sheet(isPresented: $showTermsWebView) {
            WebView(url: URL(string: "https://haptic.software/terms")!)
        }
        .sheet(isPresented: $showPrivacyWebView) {
            WebView(url: URL(string: "https://haptic.software/privacy")!)
        }
    }
    
    func buy() async {
        do {
            withAnimation {
                self.isPurchasing = true
            }
            if try await store.purchase(selectedOffer!) != nil {
                withAnimation {
                    self.isPurchasing = false
                    self.hasPurchased = true
                    presentationMode.wrappedValue.dismiss()
                }
            }
        } catch StoreError.failedVerification {
            errorMessage = "Your purchase could not be verified by the App Store."
            showErrorAlert = true
        } catch {
            print("Failed purchase: \(error)")
        }
    }
}
