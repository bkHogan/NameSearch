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

class CartRepository: BaseRepository, CartRepositoryType, DecodeJson {
    
    func performPayment<T>(params: [String : String], modelType: T.Type, completionHandler: @escaping Completion<T>) where T : Decodable {
        
        networkManager.run(baseUrl: EndPoint.baseUrl, path: APIPath.payment.rawValue, params: params, requestType:RequestType.post) { data, error in
            
            guard let data = data, error == nil else {
                completionHandler(.failure(.errorWith(message: error!.localizedDescription)))
                return
            }
            // Parsing data using JsonDecoder
            
            if let result = self.decodeObject(input:data, type:modelType.self) {
                completionHandler(.success(result))
            }else {
                completionHandler(.failure(.parsinFailed(message:"")))
            }
        }
    }
}
