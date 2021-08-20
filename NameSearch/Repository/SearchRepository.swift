//
//  SearchRepository.swift
//  NameSearch
//
//  Created by MAC on 20/08/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation

protocol SearchRepositoryType {
    func getExactDoamins<T:Decodable>( keyWord:String,
                          type:T.Type,
                          completionHandler:@escaping Completion<T>)
    func getSuggestedDoamins<T:Decodable>( keyWord:String,
                              type:T.Type,
                              completionHandler:@escaping Completion<T>)
}

class SearchRepository:BaseRepository, SearchRepositoryType, DecodeJson {
    
    func getExactDoamins<T>(keyWord:String, type: T.Type, completionHandler: @escaping Completion<T>) where T : Decodable {
        
        networkManager.run(baseUrl: EndPoint.baseUrl, path: APIPath.searchExact.rawValue, params: ["q":keyWord], requestType:RequestType.get) { data, error in
            
            guard let data = data, error == nil else {
                completionHandler(.failure(.errorWith(message: error!.localizedDescription)))
                return
            }
            // Parsing data using JsonDecoder
            
            if let result = self.decodeObject(input:data, type:type.self) {
                completionHandler(.success(result))
            }else {
                completionHandler(.failure(.parsinFailed(message:"")))
            }
        }
    }
    
    func getSuggestedDoamins<T>(keyWord: String, type: T.Type, completionHandler: @escaping Completion<T>) where T : Decodable {
        
        networkManager.run(baseUrl: EndPoint.baseUrl, path: APIPath.searchSpins.rawValue, params: ["q":keyWord], requestType:RequestType.get) { data, error in
            
            guard let data = data, error == nil else {
                completionHandler(.failure(.errorWith(message: error!.localizedDescription)))
                return
            }
            // Parsing data using JsonDecoder
            
            if let result = self.decodeObject(input:data, type:type.self) {
                completionHandler(.success(result))
            }else {
                completionHandler(.failure(.parsinFailed(message:"")))
            }
        }
    }    
}
