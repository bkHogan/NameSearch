//
//  SearchViewModelTests.swift
//  NameSearchTests
//
//  Created by MAC on 20/08/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import XCTest
@testable import NameSearch

class SearchViewModelTests: XCTestCase {

    var viewModel:SearchViewModel!
    let repository = MockSearchRepository()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
       
        let vc:SearchViewType = DomainSearchViewController()
        viewModel = SearchViewModel(repository: repository, searchView: vc)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_exact_suggested_search_success() {
        
        var keyWord:String? = "a"
        
        viewModel.search(keyWord: keyWord)
        
        XCTAssertNotNil(viewModel.exactMatchDomains)
        XCTAssertNotNil(viewModel.suggestedDomains)
        
        XCTAssertEqual(viewModel.domains.count, 21)
        
        
         keyWord = nil
        
        viewModel.search(keyWord: keyWord)
        
        XCTAssertNil(viewModel.exactMatchDomains)
        XCTAssertNil(viewModel.suggestedDomains)
        
        XCTAssertEqual(viewModel.domains.count, 0)
    }
    
    func test_exact_suggested_search_failure() {
        
        repository.exactDomainSuccess = false
        repository.suggestedDomainSucces = false
        
        viewModel.search(keyWord: "a")
        
        XCTAssertNil(viewModel.exactMatchDomains)
        XCTAssertNil(viewModel.suggestedDomains)
        
        XCTAssertEqual(viewModel.domains.count, 0)
    }
    
    func test_exact_search_success_suggested_search_failure() {
        
        repository.exactDomainSuccess = true
        repository.suggestedDomainSucces = false
        
        viewModel.search(keyWord: "a")
        
        XCTAssertNotNil(viewModel.exactMatchDomains)
        XCTAssertNil(viewModel.suggestedDomains)
        
        XCTAssertEqual(viewModel.domains.count, 1)
    }

    func test_exact_search_failure_suggested_search_success() {
        
        repository.exactDomainSuccess = false
        repository.suggestedDomainSucces = true
        
        viewModel.search(keyWord: "a")
        
        XCTAssertNil(viewModel.exactMatchDomains)
        XCTAssertNotNil(viewModel.suggestedDomains)
        
        XCTAssertEqual(viewModel.domains.count, 20)
    }
}

class MockSearchRepository: SearchRepositoryType, DecodeJson {
    
    var exactDomainSuccess = true
    var suggestedDomainSucces = true

    func getExactDoamins<T>(keyWord: String, type: T.Type, completionHandler: @escaping Completion<T>) where T : Decodable {
        let bundle = Bundle(for:MockSearchRepository.self)
        
        var fileName = ""
        
        if exactDomainSuccess && type == DomainSearchExactMatchResponse.self {
            fileName = "ExactDomainSearchSuccessResonse"
        }else {
            fileName = "ExactDomainSearchFailureResonse"
        }
        guard let url = bundle.url(forResource:fileName, withExtension:"json"),
              let data = try? Data(contentsOf: url),
              let output = self.decodeObject(input:data, type:type.self)
        else {
            completionHandler(.failure(NetworkError.parsinFailed(message:"Failed to get response")))
            return
        }
        completionHandler(.success(output))
    }
    
    func getSuggestedDoamins<T>(keyWord: String, type: T.Type, completionHandler: @escaping Completion<T>) where T : Decodable {
        let bundle = Bundle(for:MockSearchRepository.self)
        
        var fileName = ""
        if suggestedDomainSucces && type == DomainSearchRecommendedResponse.self {
            fileName = "SuggestedDomainSearchSuccessResonse"
        }else {
            fileName = "SuggestedDomainSearchFailureResonse"
        }
        
        guard let url = bundle.url(forResource:fileName, withExtension:"json"),
              let data = try? Data(contentsOf: url),
              let output = self.decodeObject(input:data, type:type.self)
        else {
            completionHandler(.failure(NetworkError.parsinFailed(message:"Failed to get response")))
            return
        }
        completionHandler(.success(output))
    }
    
}



