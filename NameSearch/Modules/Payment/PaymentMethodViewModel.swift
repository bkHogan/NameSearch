//
//  PaymentMethodViewModel.swift
//  NameSearch
//
//  Created by MAC on 20/08/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation

protocol PaymentType {
    var numberOfPaymentMethods:Int { get }
    func fetchPaymentMethods()
    func paymentMethod(for index:Int)-> PaymentMethod?
}

class PaymentMethodViewModel: PaymentType {

    var numberOfPaymentMethods: Int {
        return paymentMethods?.count ?? 0
    }
    var repository:PaymentRepositoryType
    weak var paymentMethodsView:PaymentMethodsViewType?
    private var paymentMethods: [PaymentMethod]?

    init(repository:PaymentRepositoryType = PaymentRepository(), paymentMethodsView:PaymentMethodsViewType) {
        self.repository = repository
        self.paymentMethodsView = paymentMethodsView
    }
    
    func fetchPaymentMethods() {
        repository.getPaymentMethods(modelType: PaymentMethod.self) { [weak self] result in
            switch result {
            case .success(let response):
                self?.paymentMethods = response
                self?.paymentMethodsView?.updateUI()
            case .failure(let error):
                self?.paymentMethods = nil
                print(error)
            }
        }
    }
    
    func paymentMethod(for index: Int) -> PaymentMethod? {
        if let _paymentMentods = paymentMethods, index >= 0 , index < _paymentMentods.count {
            return _paymentMentods[index]
        }
        return nil
    }
}
