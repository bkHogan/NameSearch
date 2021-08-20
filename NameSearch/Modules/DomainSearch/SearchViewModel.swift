//
//  SearchViewModel.swift
//  NameSearch
//
//  Created by MAC on 19/08/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation


struct Domain {
    let name: String
    let price: String
    let productId: Int
}

protocol Searchable {
    var domains: [Domain] { get }
    func search(keyWord:String?)
}

class SearchViewModel: Searchable {
    
    private var repository:SearchRepositoryType
    weak var searchView:SearchViewType?
    private var exactMatchDomains:DomainSearchExactMatchResponse?
    private var suggestedDomains:DomainSearchRecommendedResponse?

     var domains: [Domain] {
        var output:[Domain] = []
        output.append(contentsOf:getExactDomain())
        output.append(contentsOf:getSuggestedDomain())
        return output
    }
    
    init(repository:SearchRepositoryType = SearchRepository(), searchView:SearchViewType) {
        self.repository = repository
        self.searchView = searchView
    }
    
    
    func search(keyWord: String?) {
        guard let text = keyWord, text.count > 0 else {
            return
        }
                
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()

        repository.getExactDoamins(keyWord:text, type: DomainSearchExactMatchResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                self?.exactMatchDomains = response
            case .failure(let error):
                print(error)
                self?.exactMatchDomains = nil

            }
            dispatchGroup.leave()

        }
        
        dispatchGroup.enter()
        
        repository.getSuggestedDoamins(keyWord:text, type: DomainSearchRecommendedResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                self?.suggestedDomains = response
                
            case .failure(let error):
                self?.suggestedDomains = nil
            }
            
            dispatchGroup.leave()
            
        }

        dispatchGroup.notify(queue: DispatchQueue.main, work: DispatchWorkItem(block: {
            self.searchView?.updateUI()
        }))
        
    }
    
    private func getExactDomain()-> [Domain] {
        var output:[Domain] = []
        if let exactMatchDomains = exactMatchDomains {
            let exactDomainPriceInfo = exactMatchDomains.products.first(where: { $0.productId == exactMatchDomains.domain.productId })!.priceInfo
            let exactDomain = Domain(name: exactMatchDomains.domain.fqdn,
                                     price: exactDomainPriceInfo.currentPriceDisplay,
                                     productId: exactMatchDomains.domain.productId)
            output.append(exactDomain)
        }
        return output
    }
    
    private func getSuggestedDomain()-> [Domain] {
        var output:[Domain] = []
        if let suggestedDomains = suggestedDomains {
            let domains = suggestedDomains.domains.map { domain -> Domain in
                let priceInfo = suggestedDomains.products.first(where: { price in
                    price.productId == domain.productId
                })!.priceInfo

                return Domain(name: domain.fqdn, price: priceInfo.currentPriceDisplay, productId: domain.productId)
            }
            output.append(contentsOf:domains)
        }
        return output
    }
}
