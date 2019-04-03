//
//  PriceManager.swift
//  LocationNotes
//
//  Created by Igor Chernobai on 3/10/19.
//  Copyright © 2019 Igor Chernobai. All rights reserved.
//  LocationNotes.fullVersion

import UIKit
import StoreKit

var fullVersionProduct: SKProduct? 

let idFullVersion = "LocationNotes.fullVersion"

class PriceManager: NSObject {
    
    
    

    func getPriceForProduct(idProduct: String) {
        if !SKPaymentQueue.canMakePayments() {
            print("can't make a payment")
            return
        }
       let request = SKProductsRequest(productIdentifiers: [idProduct])
        request.delegate = self
        request.start()
        
        
    }
}




extension PriceManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.invalidProductIdentifiers.count != 0 {
            print("Have not actual products: \(response.invalidProductIdentifiers)")
        }
        if response.products.count > 0 {
            fullVersionProduct = response.products[0]
            print("Recieved product: \(String(describing: fullVersionProduct?.localizedTitle))")
        }
    }
}
