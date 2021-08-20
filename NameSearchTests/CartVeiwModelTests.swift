//
//  CartVeiwModelTests.swift
//  NameSearchTests
//
//  Created by MAC on 20/08/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import XCTest
@testable import NameSearch

class CartVeiwModelTests: XCTestCase {

    var viewModel:CartViewModel!
    let repository = MockCartRepository()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
       
        let vc:CartViewType = CartViewController()
        viewModel = CartViewModel(repository: repository, cartView: vc)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_isPaymentSelected() {
        
        PaymentsManager.shared.selectedPaymentMethod = PaymentMethod(name:"test", token:"test", lastFour: "1234", displayFormattedEmail:"test@gmail.com")
                
        XCTAssertTrue(viewModel.isPaymentMethodSelected)
        
        PaymentsManager.shared.selectedPaymentMethod = nil
                
        XCTAssertFalse(viewModel.isPaymentMethodSelected)
    }

    func test_paymentButtonTitle() {
        
        // When Payment method is selected but no Domain Selected
        
        ShoppingCart.shared.domains = []
        PaymentsManager.shared.selectedPaymentMethod = PaymentMethod(name:"test", token:"test", lastFour: "1234", displayFormattedEmail:"test@gmail.com")
                
        var title = viewModel.getPayButtonTitle()
        
        XCTAssertEqual(title, "Pay $0.00 Now")
        
        // When No payment method is selected
        PaymentsManager.shared.selectedPaymentMethod = nil
                
         title = viewModel.getPayButtonTitle()
        
        XCTAssertEqual(title, "Select a Payment Method")
        
        
        // When Domain is selected and payment is not selected
        
        ShoppingCart.shared.domains.append(Domain(name:"a.com", price:"$11.43", productId:1))
        
        PaymentsManager.shared.selectedPaymentMethod = nil
                
         title = viewModel.getPayButtonTitle()
        
        XCTAssertEqual(title, "Select a Payment Method")
        
        
        // When Domain is selected and payment is selected
                
        PaymentsManager.shared.selectedPaymentMethod = PaymentMethod(name:"test", token:"test", lastFour: "1234", displayFormattedEmail:"test@gmail.com")
                
         title = viewModel.getPayButtonTitle()
        
        XCTAssertEqual(title, "Pay $11.43 Now")
        
        
        // When tow Domains are  selected and payment is selected
               
        ShoppingCart.shared.domains.append(Domain(name:"b.com", price:"$10.00", productId:1))

        PaymentsManager.shared.selectedPaymentMethod = PaymentMethod(name:"test", token:"test", lastFour: "1234", displayFormattedEmail:"test@gmail.com")
                
         title = viewModel.getPayButtonTitle()
        
        XCTAssertEqual(title, "Pay $21.43 Now")
    }
    
    func test_getDomain() {
        
        // When No Domain is selected
        ShoppingCart.shared.domains = []
                
        var domain = viewModel.getDomain(for: 1)
        
        XCTAssertNil(domain)
        
         domain = viewModel.getDomain(for: -1)
        
        XCTAssertNil(domain)
        
        
        // When Domain is added
        
        ShoppingCart.shared.domains.append(Domain(name:"a.com", price:"$11.43", productId:1))
        
        domain = viewModel.getDomain(for: 0)
       
        XCTAssertEqual(viewModel.numberOfDomains, 1)
         XCTAssertNotNil(domain)
        
        XCTAssertEqual(domain?.name, "a.com")
        XCTAssertEqual(domain?.price, "$11.43")
        XCTAssertEqual(domain?.productId, 1)

        // Access more out of index domain
        
        domain = viewModel.getDomain(for: 1)
       
       XCTAssertNil(domain)
    }
    
    
    func test_performPayment_success() {
        
        XCTAssertNil(viewModel.transaction)

        AuthManager.shared.token = "token"
        PaymentsManager.shared.selectedPaymentMethod = PaymentMethod(name: "card", token:"1234", lastFour:"1234", displayFormattedEmail:"email.com")
        viewModel.performPayment()
        
        XCTAssertNotNil(viewModel.transaction)
    }
    
    func test_performPayment_failure() {
        
        XCTAssertNil(viewModel.transaction)

        AuthManager.shared.token = "token"
        PaymentsManager.shared.selectedPaymentMethod = PaymentMethod(name: "card", token:"1234", lastFour:"1234", displayFormattedEmail:"email.com")
        
        repository.response = "Paymentfailure"
        viewModel.performPayment()
        
        XCTAssertNil(viewModel.transaction)
    }
}

class MockCartRepository: CartRepositoryType, DecodeJson {
    
    var response = "PaymentSuccess"
    
    func performPayment<T:Decodable>(params:[String:String], modelType:T.Type, completionHandler:@escaping Completion<T> ) {
        let bundle = Bundle(for:MockCartRepository.self)
        
        guard let url = bundle.url(forResource:response, withExtension:"json"),
              let data = try? Data(contentsOf: url),
              let output = self.decodeObject(input:data, type:modelType.self)
        else {
            completionHandler(.failure(NetworkError.parsinFailed(message:"Failed to get response")))
            return
        }
        completionHandler(.success(output))
    }
}
