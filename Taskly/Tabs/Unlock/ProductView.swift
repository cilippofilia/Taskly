//
//  ProductVie.swift
//  Taskly
//
//  Created by Filippo Cilia on 15/04/2021.
//

import StoreKit
import SwiftUI

struct ProductView: View {
    @EnvironmentObject var unlockManager: UnlockManager
    let product: SKProduct

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Get Unlimited Projects")
                    .font(.headline)
                    .padding(.top, 20)
                Text("You can add 3 projects for free, or pay \(product.localizedPrice) to add unlimited projects.")
                Text("If you already bought the unlock on another device, press Restore Purchases.")

                Button("Buy: \(product.localizedPrice)", action: unlock)
                    .buttonStyle(PurchaseButton())

                Button("Restore Purchases", action: unlockManager.restore)
                    .buttonStyle(PurchaseButton())

            }
        }
    }

    func unlock() {
        unlockManager.buy(product: product)
    }
}
