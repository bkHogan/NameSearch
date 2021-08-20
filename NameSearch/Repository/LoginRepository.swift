//
//  LoginRepository.swift
//  NameSearch
//
//  Created by MAC on 20/08/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation


//typealias Completion<T:Decodable> =  ((Result<T, NetworkError>) -> Void)


protocol LoginRepositoryType {
    func login<T:Decodable>(userName:String, password:String, modelType:T.Type, completionHandler:@escaping Completion<T> )
}

class LoginRepository:BaseRepository, LoginRepositoryType, DecodeJson {
    
    func login<T:Decodable>(userName:String, password:String, modelType:T.Type, completionHandler:@escaping Completion<T>) {
        
        networkManager.run(baseUrl: EndPoint.baseUrl, path: APIPath.login.rawValue, params: [:], requestType:RequestType.post) { data, error in
            
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
