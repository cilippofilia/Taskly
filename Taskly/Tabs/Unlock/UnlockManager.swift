//
//  UnlockManager.swift
//  Taskly
//
//  Created by Filippo Cilia on 14/04/2021.
//

import Combine
import StoreKit

class UnlockManager: NSObject, ObservableObject, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    enum RequestState {
        case loading
        case loaded(SKProduct)
        case failed(Error?)
        case purchased
        case deferred
    }

    private enum StoreError: Error {
        case invalidIdentifiers, missingProduct
    }

    @Published var requestState = RequestState.loading

    private let dataController: DataController
    private let request: SKProductsRequest
    private var loadedProducts = [SKProduct]()

    var canMakePayments: Bool {
        SKPaymentQueue.canMakePayments()
    }

    init(dataController: DataController) {
        // Store the data controller we were sent.
        self.dataController = dataController
        // Prepare to look for our unlock product.
        let productIDs = Set(["me.cilia.filippo.Taskly.unlock"])
        request = SKProductsRequest(productIdentifiers: productIDs)
        // This is required because we inherit from NSObject.
        super.init()
        // Start watching the payment queue.
        SKPaymentQueue.default().add(self)

        guard dataController.fullVersionUnlocked == false else { return }
        // Set ourselves up to be notified when the product request completes.
        request.delegate = self
        // Start the request
        request.start()
    }

    deinit {
        SKPaymentQueue.default().remove(self)
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            // Store the returned products for later, if we need them.
            self.loadedProducts = response.products

            guard let unlock = self.loadedProducts.first else {
                self.requestState = .failed(StoreError.missingProduct)
                return
            }

            if response.invalidProductIdentifiers.isEmpty == false {
                print("ALERT: Received invalid product identifiers: \(response.invalidProductIdentifiers)")
                self.requestState = .failed(StoreError.invalidIdentifiers)
                return
            }

            self.requestState = .loaded(unlock)
        }
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        DispatchQueue.main.async { [self] in
            for transaction in transactions {
                switch transaction.transactionState {
                case .purchased, .restored:
                    self.dataController.fullVersionUnlocked = true
                    self.requestState = .purchased
                    queue.finishTransaction(transaction)

                case .failed:
                    if let product = loadedProducts.first {
                        self.requestState = .loaded(product)
                    } else {
                        self.requestState = .failed(transaction.error)
                    }

                    queue.finishTransaction(transaction)

                case .deferred:
                    self.requestState = .deferred

                default:
                    break
                }
            }
        }
    }

    func buy(product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    func restore() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}


// 1-   In UnlockManager, don’t just hard-code a single product ID – either put several in there, or for added flexibility fetch the data from a remote server. This allows you to enable or disable purchases remotely.
// 2- Modify the loaded request state to store an array of products.
// 3- Update your UI to show a list of products, rather than a single, hard-coded button. This would mean using the localized title of your products alongside the localized price.
// 4- Inside the updatedTransactions method, check the transaction.payment.productIdentifier property to see what they actually bought.
// 5- Store the product ID of each purchased item, either using UserDefaults or the iOS keychain for extra security, then adjust your app’s settings at launch by reading the array of purchased IDs.
