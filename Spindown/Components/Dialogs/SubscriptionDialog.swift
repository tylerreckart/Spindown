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
            Text("Development of this app would not be possible without our subscribers. Show your support and help fund the development of new features by subscribing today.")
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
    var store: Store

    @Binding var selectedOffer: Product?
    @Binding var hasPurchased: Bool
    @Binding var showManageSubscriptions: Bool
    
    var buy: () async -> ()
    
    @State private var showTermsSheet: Bool = false
    @State private var showPrivacySheet: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 0) {
                VStack(spacing: 0) {
                    Image("SpindownIcon")
                        .resizable()
                        .frame(maxWidth: 64, maxHeight: 64)
                }
                .padding([.top, .bottom])
                
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
                            Text("Try Spindown completely free for two weeks. Cancel anytime.")
                                .font(.system(size: 12))
                                .foregroundColor(Color(.systemGray))
                                .padding(.bottom, 10)
                                .padding(.horizontal)
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.center)
                            
                            UIButton(text: "Start Your Free Trial", color: UIColor(named: "PrimaryRed")!, action: {
                                Task {
                                    await buy()
                                }
                            })
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
                            self.showTermsSheet.toggle()
                        })
                    UIButtonOutlined(
                        text: "Privacy Policy",
                        fill: UIColor(named: "DeepGray")!,
                        color: UIColor(named: "AccentGrayDarker")!,
                        action: {
                            self.showPrivacySheet.toggle()
                        }
                    )
                }
                .padding()
            }
        }
        .foregroundColor(.white)
        .background(Color(UIColor(named: "DeepGray")!))
        .interactiveDismissDisabled(true)
        .sheet(isPresented: $showTermsSheet) {
            TermsOfUseView()
        }
        .sheet(isPresented: $showPrivacySheet) {
            PrivacyPolicyView()
        }
    }
}

struct SubscriptionDialog: View {
    var store: Store

    @State private var selectedOffer: Product?
    @State private var hasPurchased: Bool = false

    @State private var showManageSubscriptions: Bool = false
    @State private var errorMessage: String?
    @State private var showErrorAlert: Bool = false
    
    @State private var dialogOpacity: CGFloat = 0
    @State private var dialogOffset: CGFloat = 0

    var body: some View {
        SubscriptionView(
            store: store,
            selectedOffer: $selectedOffer,
            hasPurchased: $hasPurchased,
            showManageSubscriptions: $showManageSubscriptions,
            buy: buy
        )
        .padding()
        .frame(maxWidth: 500, maxHeight: 500)
        .cornerRadius(16)
        .opacity(dialogOpacity)
        .scaleEffect(dialogOffset)
        .shadow(color: Color.black.opacity(0.1), radius: 15)
        .manageSubscriptionsSheet(isPresented: $showManageSubscriptions)
        .onAppear {
            if !store.purchasedSubscriptions.isEmpty {
                hasPurchased = true
            }
            
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
            print(selectedOffer as Any)
            print(store.subscriptions)
            if try await store.purchase(selectedOffer!) != nil {
                withAnimation {
                    hasPurchased = true
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

struct SubscriptionDialog_Previews: PreviewProvider {
    @StateObject static var store: Store = Store()
    static var previews: some View {
        SubscriptionDialog(store: store).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
