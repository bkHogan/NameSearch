//
//  CartRepository.swift
//  NameSearch
//
//  Created by MAC on 20/08/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation

protocol CartRepositoryType {
    func performPayment<T:Decodable>(params:[String:String], modelType:T.Type, completionHandler:@escaping Completion<T> )
}

class CartRepository: BaseRepository, CartRepositoryType {
    
    func performPayment<T>(params: [String : String], modelType: T.Type, completionHandler: @escaping Completion<T>) where T : Decodable {
        
        networkManager.run(baseUrl: EndPoint.baseUrl, path: APIPath.payment.rawValue, params: params, requestType:RequestType.post) { data, error in
            
            guard let data = data, error == nil else {
                completionHandler(.failure(.errorWith(message: error!.localizedDescription)))
                return
            }
            // Parsing data using JsonDecoder
            
            if let result = try? JSONDecoder().decode(T.self, from: data) {
                completionHandler(.success(result))
            }else {
                completionHandler(.failure(.parsinFailed(message:"")))
            }
        }
    }
}
