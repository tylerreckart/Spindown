//
//  SubscriptionDialog.swift
//  Spindown
//
//  Created by Tyler Reckart on 2/14/23.
//

import SwiftUI
import StoreKit

struct SubscriptionTile: View {
    var sub: Product?
    @Binding var selectedOffer: Product?

    var body: some View {
        Button(action: {
            selectedOffer = sub
        }) {
            VStack {
                VStack(spacing: 0) {
                    Text(sub?.id == "com.Spindown.subscription.yearly" ? "Yearly" : "Monthly")
                        .font(.system(size: 12, weight: .bold))
                        .padding(.top, 6)
                    VStack(spacing: 0) {
                        Text("\(sub?.displayPrice ?? "$0.99")")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.bottom, 5)
                        Text("Cancel anytime")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(UIColor(named: "DeepGray")!))
                    .cornerRadius(6)
                    .padding(4)
                    .foregroundColor(.white)
                }
            }
            .frame(width: 120, height: 120)
            .foregroundColor(selectedOffer == sub ? .black : .white)
            .background(selectedOffer == sub ? .white : Color(UIColor(named: "AccentGrayDarker")!))
            .cornerRadius(8)
        }
        .onAppear {
            if selectedOffer == nil && sub?.id == "com.Spindown.subscription.yearly" {
                selectedOffer = sub
            }
        }
    }
}

struct Pitch: View {
    var store: Store

    @Binding var selectedOffer: Product?

    var body: some View {
        VStack(alignment: .center) {
            Text("Development of this app would not be possible without our subscribers. Show your support and help fund the development of new features by subscribing today.\n\nBoth plans offer a free 2-week trial. You may cancel anytime before the trial ends and you won't be charged.")
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 5)
                .padding(.bottom)
                .padding(.horizontal)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(UIColor(named: "AccentGray")!))

            if !store.subscriptions.isEmpty {
                VStack(alignment: .center) {
                    HStack {
                        Spacer()
                        Text("Choose a Plan")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                        Spacer()
                    }
                    HStack(spacing: 20) {
                        ForEach(store.subscriptions) { sub in
                            SubscriptionTile(sub: sub, selectedOffer: $selectedOffer)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                }
            }
        }
    }
}

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
        ScrollView {
            VStack(alignment: .center, spacing: 0) {
                VStack(spacing: 0) {
                    Image(uiImage: icon!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 72)
                        .cornerRadius(20)
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
                
                
                if !hasPurchased {
                    Pitch(store: store, selectedOffer: $selectedOffer)
                        .padding(.bottom, 20)
                } else {
                    VStack {
                        Text("Thank you for supporting Spindown as a premium subscriber. Your contributions help fund new features and cover the costs of development.")
                            .padding(.bottom)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal)
                }
                
                VStack(spacing: 20) {
                    if !store.subscriptions.isEmpty {
                        if !hasPurchased {
                            if !isPurchasing {
                                UIButton(text: "Subscribe", color: UIColor(named: "PrimaryRed")!, action: {
                                    Task {
                                        await buy()
                                    }
                                })
                            } else {
                                Spinner()
                            }
                        } else {
                            UIButton(text: "Change or Cancel Subscription", color: UIColor(named: "PrimaryRed")!, action: {
                                Task {
                                    showManageSubscriptions.toggle()
                                }
                            })
                        }
                    }
                    
                    
                    UIButtonOutlined(text: "Restore Previous Purchases", fill: UIColor(named: "DeepGray")!, color: UIColor(named: "AccentGrayDarker")!, action: {
                        Task {
                            try? await AppStore.sync()
                        }
                    })
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
                            if let url = URL(string: "https://haptic.software/terms") {
                                UIApplication.shared.open(url)
                            }
                        })
                    UIButtonOutlined(
                        text: "Privacy Policy",
                        fill: UIColor(named: "DeepGray")!,
                        color: UIColor(named: "AccentGrayDarker")!,
                        action: {
                            if let url = URL(string: "https://haptic.software/privacy") {
                                UIApplication.shared.open(url)
                            }
                        }
                    )
                }
                .padding()
            }
        }
        .foregroundColor(.white)
        .background(Color(UIColor(named: "DeepGray")!))
        .interactiveDismissDisabled(true)
        .onChange(of: store.purchasedSubscriptions) { purchases in
            
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
