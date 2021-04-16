//
//  SKProduct-LocalizedPrice.swift
//  Taskly
//
//  Created by Filippo Cilia on 15/04/2021.
//

import StoreKit

extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}
