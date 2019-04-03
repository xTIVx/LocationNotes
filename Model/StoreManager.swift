//
//  StoreManager.swift
//  LocationNotes
//
//  Created by Igor Chernobai on 4/2/19.
//  Copyright © 2019 Igor Chernobai. All rights reserved.
//

import UIKit
import StoreKit

class StoreManager: NSObject {
    static var isFullVersion: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "isFull")
            UserDefaults.standard.synchronize()
        }
        get {
           return UserDefaults.standard.bool(forKey: "isFull")
        }
    }
    
    func buyFullVersion() {
        if let fullVersionProduct = fullVersionProduct {
            let payment = SKPayment(product: fullVersionProduct)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else {
            if !SKPaymentQueue.canMakePayments() {
                print("can't make a payment")
                return
            }
            let request = SKProductsRequest(productIdentifiers: [idFullVersion])
            request.delegate = self
            request.start()
        }
    }
    func restoreFullVersion() {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}


extension StoreManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            if transaction.transactionState == .deferred {
                print("Transaction is deferred")
            }
            if transaction.transactionState == .failed {
                print("Transaction is failed")
                print("Error: \(String(describing: transaction.error?.localizedDescription))")
                queue.finishTransaction(transaction)
                queue.remove(self)
            }
            if transaction.transactionState == .purchased {
                print("Transaction is purchased")
                if transaction.payment.productIdentifier == idFullVersion {
                    StoreManager.isFullVersion = true
                }
                queue.finishTransaction(transaction)
                queue.remove(self)
            }
            if transaction.transactionState == .purchasing {
                print("Transaction is purchasing")
            }
            if transaction.transactionState == .restored {
                print("Transaction is restored")
                if transaction.payment.productIdentifier == idFullVersion {
                    StoreManager.isFullVersion = true
                }
                queue.finishTransaction(transaction)
                queue.remove(self)
            }
        }
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        
    }
    
    
}

class BuyingForm {
    
    var isNeedToShow: Bool {
        if StoreManager.isFullVersion  {
            return false
        }
        if notes.count <= 3 {
            return false
        }
        return true
    }
    
    var storeManager = StoreManager()
    
    func showForm(inController: UIViewController) {
        if let fullVersionProduct = fullVersionProduct {
           let alertController = UIAlertController(title: fullVersionProduct.localizedTitle, message: fullVersionProduct.localizedDescription, preferredStyle: .alert)
            
            var symbol = ""
            
            if let symbolLet = fullVersionProduct.priceLocale.currencySymbol {
                symbol = symbolLet
            }
            
            
            let actionBuy = UIAlertAction(title: "Buy for \(String(describing: symbol)) \(fullVersionProduct.price)", style: .default) { (alert) in
                self.storeManager.buyFullVersion()
            }
            let actionRestore = UIAlertAction(title: "Restore", style: .default) { (alert) in
                self.storeManager.restoreFullVersion()
            }
            let actionCancel = UIAlertAction(title: "Cancel", style: .default) { (alert) in
                
            }
            alertController.addAction(actionBuy)
            alertController.addAction(actionRestore)
            alertController.addAction(actionCancel)
            
            inController.present(alertController, animated: true, completion: nil)
        }
    }
}


extension StoreManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.invalidProductIdentifiers.count != 0 {
            print("Have not actual products: \(response.invalidProductIdentifiers)")
        }
        if response.products.count > 0 {
            fullVersionProduct = response.products[0]
            print("Recieved product in StoreManager: \(String(describing: fullVersionProduct?.localizedTitle))")
            self.buyFullVersion()
        }
    }
}
