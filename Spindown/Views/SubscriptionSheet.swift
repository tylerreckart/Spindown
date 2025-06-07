import SwiftUI
import StoreKit

struct SubscriptionView: View {
    @AppStorage("isSubscribed") private var currentEntitlement: Bool = false
    @Environment(\.presentationMode) var presentationMode
    var store: Store

    // Store data
    @State private var selectedOffer: Product? // Keep as Optional
    @State private var isPurchasing: Bool = false
    @State private var hasPurchased: Bool = false
    // Sheet views
    @State private var showManageSubscriptions: Bool = false
    // Error handling
    @State private var errorMessage: String?
    @State private var showErrorAlert: Bool = false
    @State private var showNoSubscriptionAlert: Bool = false
    // Web views
    @State private var showPrivacyWebView: Bool = false
    @State private var showTermsWebView: Bool = false

    // (icon property remains the same)
    var icon: UIImage? {
        // ... icon logic ...
        guard let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? NSDictionary,
              let primaryIconsDictionary = iconsDictionary["CFBundlePrimaryIcon"] as? NSDictionary,
              let iconFiles = primaryIconsDictionary["CFBundleIconFiles"] as? NSArray,
              let lastIcon = iconFiles.lastObject as? String,
              let icon = UIImage(named: lastIcon) else {
                return nil
        }
        return icon
    }


    var body: some View {
        ZStack {
            ScrollView {
                // --- UI remains largely the same ---
                VStack(alignment: .center, spacing: 0) {
                    // ... Icon and Title ...
                    VStack(spacing: 0) {
                        if let iconImage = icon { // Safely unwrap icon here too
                            Image(uiImage: iconImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 72)
                                .cornerRadius(18)
                        }
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
                        // --- FIX: Disable button when selectedOffer is nil ---
                        UIButton(text: "Subscribe",
                               color: selectedOffer != nil ? UIColor(named: "PrimaryRed")! : UIColor(named: "AccentGrayDarker")!, // Dim color when disabled
                               action: {
                            Task {
                                await buy()
                            }
                        })
                        .disabled(selectedOffer == nil) // Disable the button
                        .opacity(selectedOffer != nil ? 1.0 : 0.6) // Reduce opacity when disabled


                        UIButtonOutlined(text: "Restore Previous Purchases", fill: UIColor(named: "DeepGray")!, color: UIColor(named: "AccentGrayDarker")!, action: {
                            self.isPurchasing.toggle()
                            Task {
                                try? await AppStore.sync()
                                await store.updateCustomerProductStatus() // Make sure status is updated after sync
                                self.isPurchasing.toggle()

                                if (store.purchasedSubscriptions.isEmpty) {
                                    self.showNoSubscriptionAlert.toggle()
                                } else {
                                    // Optional: Dismiss if restore was successful and entitlement granted
                                    self.currentEntitlement = true // Assume success if purchases found
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        })
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)

                // --- Footer text and buttons remain the same ---
                VStack {
                    Text("Payment for your subscription will be charged to your Apple ID account at the confirmation of purchase. Subscription automatically renews unless cancelled at least 24 hours before the end of the current period. Your account will be charged for renewal within 24 hours prior to the end of the current period.\n\nYou can manage and cancel your subscriptions by got to your account settings in the App Store after purchase.")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.systemGray))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal)

                HStack {
                    Link("Privacy Policy", destination: URL(string: "https://www.haptic.software/privacy.html")!)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    Link("Terms of Use", destination: URL(string: "https://www.haptic.software/terms.html")!)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding([.horizontal, .top])
            }

            if (self.isPurchasing) {
                Color.black.opacity(0.2)
                    .edgesIgnoringSafeArea(.all)
                Spinner()
            }
        }
        .foregroundColor(.white)
        .background(Color(UIColor(named: "DeepGray")!))
        .onChange(of: store.purchasedSubscriptions) { subscriptions in
            if !subscriptions.isEmpty { // Check if it's not empty
                Task { // Ensure UI updates run on main actor
                     await MainActor.run {
                        if self.isPurchasing {
                            self.isPurchasing = false
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .alert(isPresented: $showErrorAlert, error: ValidationError.NaN) { _ in // Use a specific error type if needed
            Button("Ok") {
                showErrorAlert = false
                errorMessage = nil // Clear the error message
            }
        } message: { _ in
            Text(errorMessage ?? "An unknown error occurred. Please try again.")
        }
        .alert(isPresented: $showNoSubscriptionAlert) { // Simpler alert for no subscription found
             Alert(title: Text("No Subscription Found"),
                   message: Text("We couldn't find an active subscription associated with your account."),
                   dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $showTermsWebView) {
            WebView(url: URL(string: "https://haptic.software/terms.html")!)
        }
        .sheet(isPresented: $showPrivacyWebView) {
            WebView(url: URL(string: "https://haptic.software/privacy.html")!)
        }
    }

    // --- FIX: Safely unwrap selectedOffer in buy() ---
    func buy() async {
        // Safely unwrap selectedOffer before proceeding
        guard let productToPurchase = selectedOffer else {
            print("Error: No subscription selected.")
            // Optionally set an error message for the user
            errorMessage = "Please select a subscription plan first."
            showErrorAlert = true
            return // Exit if no offer is selected
        }

        do {
            withAnimation {
                self.isPurchasing = true
            }
            // Use the unwrapped productToPurchase
            if try await store.purchase(productToPurchase) != nil {
                withAnimation {
                    self.isPurchasing = false
                    self.hasPurchased = true
                    presentationMode.wrappedValue.dismiss()
                    self.currentEntitlement = true
                }
            } else {
                 // Handle potential nil return (e.g., user cancelled, pending)
                 self.isPurchasing = false // Stop spinner if not successful
            }
        } catch StoreError.failedVerification {
            errorMessage = "Your purchase could not be verified by the App Store."
            showErrorAlert = true
            self.isPurchasing = false
        } catch {
            print("Failed purchase: \(error)")
            errorMessage = "An error occurred during purchase. Please try again." // Provide generic error
            showErrorAlert = true
            self.isPurchasing = false
        }
    }
}
