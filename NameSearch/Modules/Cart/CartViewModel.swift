//
//  CartViewModel.swift
//  NameSearch
//
//  Created by MAC on 20/08/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation


protocol CartType {
    var isPaymentMethodSelected:Bool { get }
    var numberOfDomains:Int { get }
    func getDomain(for index:Int)-> Domain?
    func performPayment()
    func getPayButtonTitle()-> String
}

class  CartViewModel: CartType {
    
    var numberOfDomains: Int {
        return ShoppingCart.shared.domains.count
    }
   
    var isPaymentMethodSelected:Bool {
        guard  PaymentsManager.shared.selectedPaymentMethod != nil else { return false
        }
        return true
    }
    
    var repository:CartRepositoryType

    weak var cartView:CartViewType?
    
    init(repository:CartRepositoryType = CartRepository(), cartView:CartViewType) {
        self.repository = repository
        self.cartView = cartView
    }
    
    func getPayButtonTitle()-> String {
        if !isPaymentMethodSelected {
            return "Select a Payment Method"
        } else {
            var totalPayment = 0.00

            ShoppingCart.shared.domains.forEach {
                if let priceDouble = Double($0.price.replacingOccurrences(of: "$", with: "")) {
                    totalPayment += priceDouble
                }
            }

            let currencyFormatter = NumberFormatter()
            currencyFormatter.numberStyle = .currency

            return "Pay \(currencyFormatter.string(from: NSNumber(value: totalPayment))!) Now"
        }
    }

    
    func getDomain(for index: Int)-> Domain? {
        if index >= 0 && index < ShoppingCart.shared.domains.count {
            return ShoppingCart.shared.domains[index]
        }
        return nil
    }
    func performPayment() {
        
        let params: [String: String] = [
            "auth": AuthManager.shared.token!,
            "token": PaymentsManager.shared.selectedPaymentMethod!.token
        ]
        
        repository.performPayment(params: params, modelType: Transaction.self) { [weak self] result in
            switch result {
            case .success(let response):
                self?.cartView?.updateUI()
            case .failure(let error):
                self?.cartView?.showError(error: error.localizedDescription)
            }
        }
    }
}
