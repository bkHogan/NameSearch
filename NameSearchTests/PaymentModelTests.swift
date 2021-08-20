//
//  PaymentModelTests.swift
//  NameSearchTests
//
//  Created by MAC on 20/08/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import XCTest
@testable import NameSearch

class PaymentModelTests: XCTestCase {

    var viewModel:PaymentMethodViewModel!
    let repository = MockPaymentRepository()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        PaymentsManager.shared.selectedPaymentMethod = nil
        let vc:PaymentMethodsViewType = PaymentMethodsViewController()
        viewModel = PaymentMethodViewModel(repository: repository, paymentMethodsView: vc)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_paymentMehtodSuccessAndFailure() {
        
        XCTAssertEqual(viewModel.numberOfPaymentMethods, 0)
        viewModel.fetchPaymentMethods()
        XCTAssertEqual(viewModel.numberOfPaymentMethods, 3)

        repository.response = "PaymentMethodFailure"
        
        viewModel.fetchPaymentMethods()

        XCTAssertEqual(viewModel.numberOfPaymentMethods, 0)

    }
    
    func test_getPaymentMehtod() {
        
        XCTAssertEqual(viewModel.numberOfPaymentMethods, 0)
        viewModel.fetchPaymentMethods()
        
        var payment = viewModel.paymentMethod(for: 0)
        
        XCTAssertNotNil(payment)
        
        XCTAssertEqual(payment?.title, "Visa")
        
        
         payment = viewModel.paymentMethod(for: 1)
        
        XCTAssertNotNil(payment)
        
        XCTAssertEqual(payment?.title, "MasterCard")
        XCTAssertEqual(payment?.details, "Ending in 7890")
        
        payment = viewModel.paymentMethod(for: 2)
       
       XCTAssertNotNil(payment)
       
       XCTAssertEqual(payment?.title, "PayPal")
        XCTAssertEqual(payment?.details, "gd***st@g*.com")

        
        // Out Of index
        XCTAssertNil(viewModel.paymentMethod(for: -1))
                     
        XCTAssertNil(viewModel.paymentMethod(for: 11))
    }
    
    func test_selectPayment() {
        
        XCTAssertNil(PaymentsManager.shared.selectedPaymentMethod)
        viewModel.fetchPaymentMethods()
        viewModel.selectPayment(for: 0)
        
        XCTAssertNotNil(PaymentsManager.shared.selectedPaymentMethod)

    }
}


class MockPaymentRepository: PaymentRepositoryType, DecodeJson {
 
    var response = "PaymentMethodSuccess"
    
    func getPaymentMethods<T>(modelType: T.Type, completionHandler: @escaping paymentMethodsCompletion<T>) where T : Decodable {
        
        let bundle = Bundle(for:MockLoginRepository.self)
        
        guard let url = bundle.url(forResource:response, withExtension:"json"),
              let data = try? Data(contentsOf: url),
              let output = self.decodeArray(input:data, type:modelType.self)
        else {
            completionHandler(.failure(NetworkError.parsinFailed(message:"Failed to get response")))
            return
        }
        completionHandler(.success(output))
    }
}
