//
//  PaymentRepository.swift
//  NameSearch
//
//  Created by MAC on 20/08/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation


typealias paymentMethodsCompletion<T:Decodable> =  ((Result<[T], NetworkError>) -> Void)

protocol PaymentRepositoryType {
    func getPaymentMethods<T:Decodable>(modelType:T.Type, completionHandler:@escaping paymentMethodsCompletion<T>)
}

class PaymentRepository: BaseRepository, PaymentRepositoryType {
    
    func getPaymentMethods<T:Decodable>(modelType:T.Type, completionHandler:@escaping paymentMethodsCompletion<T> ) {
        
        networkManager.run(baseUrl: EndPoint.baseUrl, path: APIPath.paymentMethods.rawValue, params: [:], requestType:RequestType.get) { data, error in
            
            guard let data = data, error == nil else {
                completionHandler(.failure(.errorWith(message: error!.localizedDescription)))
                return
            }
            // Parsing data using JsonDecoder
            
            if let result = try? JSONDecoder().decode([T].self, from: data) {
                completionHandler(.success(result))
            }else {
                completionHandler(.failure(.parsinFailed(message:"")))
            }
        }
    }
}
