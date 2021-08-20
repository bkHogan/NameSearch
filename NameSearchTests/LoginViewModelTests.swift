//
//  LoginViewModelTests.swift
//  NameSearchTests
//
//  Created by MAC on 20/08/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import XCTest
@testable import NameSearch

class LoginViewModelTests: XCTestCase {

    var viewModel:LoginViewModel!
    let repository = MockLoginRepository()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
       
        let vc:LoginViewType = LoginViewController()
        viewModel = LoginViewModel(repository: repository, loginView: vc)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLoginFailure() {
        
        repository.response = "LoginFailure"
        
        viewModel.login(userName:"", password: "")
        
        XCTAssertNil(AuthManager.shared.user?.first)
        XCTAssertNil(AuthManager.shared.user?.last)
        XCTAssertNil(AuthManager.shared.token)

    }
    
    func testLoginSuccess() {
        
        viewModel.login(userName:"", password: "")
        XCTAssertEqual(AuthManager.shared.user?.first, "GD")
        XCTAssertEqual(AuthManager.shared.user?.last, "Test")
        XCTAssertEqual(AuthManager.shared.token, "99d592a0-c316-4258-b30a-37d67ace4e44")

    }
}


class MockLoginRepository: LoginRepositoryType, DecodeJson {
    
    var response = "LoginSuccess"
    
    func login<T>(userName: String, password: String, modelType: T.Type, completionHandler: @escaping Completion<T>) where T : Decodable {
        let bundle = Bundle(for:MockLoginRepository.self)
        
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
