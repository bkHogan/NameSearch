//
//  NetworkManager.swift
//  NameSearch
//
//  Created by MAC on 19/08/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation



enum NetworkError: Error {
    case parsinFailed(message:String)
    case errorWith(message:String)
    case networkNotAvailalbe
    case malformedURL(message:String)
}


typealias Completion<T:Decodable> =  ((Result<T, NetworkError>) -> Void)

protocol Networkable {
    func get<T:Decodable>(baseUrl:String, path:String, type:T.Type, completionHandler:@escaping Completion<T>)
    func post<T:Decodable>(baseUrl:String, path:String, params:[String:String], type:T.Type, completionHandler:@escaping Completion<T>)

}

/*Created Class to inject as dependency in veiwModel and use MockService for Unit testing*/
class NetworkManager: Networkable {

    let urlSesson = URLSession(configuration: .default)
    var dataTask:URLSessionDataTask?
    func get<T>(baseUrl: String,
                path: String,
                type: T.Type,
                completionHandler: @escaping Completion<T>) where T : Decodable {
        
        dataTask?.cancel()
        guard var urlComponents = URLComponents(string:baseUrl.appending(path)) else {
            completionHandler(.failure(.malformedURL(message:"")))
            return
        }
        urlComponents.query = ""
        guard let url = urlComponents.url else {
            completionHandler(.failure(.malformedURL(message:"")))
            return
        }
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        
        
        dataTask =  urlSesson.dataTask(with:urlRequest) {  (data, responce, error)  in
            guard  let _responce = responce as? HTTPURLResponse , _responce.statusCode == 200 else {
                completionHandler(.failure(.errorWith(message: "")))
                return
            }
            guard let data = data else {
                completionHandler(.failure(.errorWith(message:"")))
                return
            }
            // Parsing data using JsonDecoder
            if let result = try? JSONDecoder().decode(T.self, from: data) {
                completionHandler(.success(result))
            }else {
                completionHandler(.failure(.parsinFailed(message:"")))
            }
        }
        dataTask?.resume()
    }
    
    func post<T>(baseUrl: String,
                 path: String,
                 params:[String:String],
                 type: T.Type,
                 completionHandler: @escaping Completion<T>) where T : Decodable {
        
        dataTask?.cancel()
        guard var urlComponents = URLComponents(string:baseUrl.appending(path)) else {
            completionHandler(.failure(.malformedURL(message:"")))
            return
        }
        urlComponents.query = ""
        guard let url = urlComponents.url else {
            completionHandler(.failure(.malformedURL(message:"")))
            return
        }
        var request = URLRequest(url: url)
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .fragmentsAllowed)

        }catch {
            completionHandler(.failure(.malformedURL(message:"")))
            return
        }

        request.httpMethod = "POST"
        
        
        dataTask =  urlSesson.dataTask(with:request) {  (data, responce, error)  in
            guard  let _responce = responce as? HTTPURLResponse , _responce.statusCode == 200 else {
                completionHandler(.failure(.errorWith(message: "")))
                return
            }
            guard let data = data else {
                completionHandler(.failure(.errorWith(message:"")))
                return
            }
            // Parsing data using JsonDecoder
            if let result = try? JSONDecoder().decode(T.self, from: data) {
                completionHandler(.success(result))
            }else {
                completionHandler(.failure(.parsinFailed(message:"")))
            }
        }
        dataTask?.resume()
    }
    
}
