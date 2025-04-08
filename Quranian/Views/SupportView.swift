//
//  SupportView.swift
//  Quranian
//
//  Created by Tasnim Almousa on 08/04/2025.
//


import SwiftUI
import StoreKit

struct SupportView: View {
    @State private var isSubscribed = false
    @State private var isPurchasing = false
    private let subscriptionID = "support.developer.001"

    var body: some View {
        VStack(spacing: 24) {
            Text("🌟 ادعم تطوير التطبيق")
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)

            Text("اشتراكك يساعدنا على تحسين التطبيق وتطوير مزايا جديدة. شكرًا لدعمك!")
                .font(.body)
                .multilineTextAlignment(.center)

            if isSubscribed {
                Text("✅ شكراً لدعمك!")
                    .foregroundColor(.green)
                    .font(.headline)
            } else {
                Button(action: {
                    Task { await purchaseSupport() }
                }) {
                    if isPurchasing {
                        ProgressView()
                    } else {
                        Text("اشترك بـ 0.99$ شهريًا")
                            .bold()
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
            }

            Spacer()
        }
        .padding()
        .task {
            await checkSubscriptionStatus()
        }
    }

    private func checkSubscriptionStatus() async {
        do {
            for await result in Transaction.currentEntitlements {
                if case .verified(let transaction) = result,
                   transaction.productID == subscriptionID {
                    isSubscribed = true
                    return
                }
            }
            isSubscribed = false
        } catch {
            print("Subscription check failed: \(error)")
        }
    }

    private func purchaseSupport() async {
        isPurchasing = true
        defer { isPurchasing = false }

        do {
            let products = try await Product.products(for: [subscriptionID])
            guard let product = products.first else { return }

            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                if case .verified(_) = verification {
                    await checkSubscriptionStatus()
                }
            default:
                break
            }
        } catch {
            print("Purchase failed: \(error)")
        }
    }
}
