//
//  NetworkManager.swift
//  NameSearch
//
//  Created by MAC on 19/08/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation

enum RequestType:String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error {
    case parsinFailed(message:String)
    case errorWith(message:String)
    case networkNotAvailalbe
    case malformedURL(message:String)
}


typealias NetworkCompletion =  (Data?, NetworkError?) -> Void

protocol Networkable {
    func run(baseUrl: String,
                 path: String,
                 params:[String:String],
                 requestType:RequestType,
                 completionHandler: @escaping NetworkCompletion)
}

/*Created Class to inject as dependency in veiwModel and use MockService for Unit testing*/
class NetworkManager: Networkable {
    
    func run(baseUrl: String,
                 path: String,
                 params:[String:String],
                 requestType:RequestType,
                 completionHandler: @escaping NetworkCompletion) {
        
        guard var urlComponents = URLComponents(string:baseUrl.appending(path)) else {
            completionHandler(nil,.malformedURL(message:""))
            return
        }
        if requestType == .get {
            var query = ""
            for (key , value) in params {
                query.append("\(key)=\(value)")
            }
            urlComponents.query = query
        }
        
        guard let url = urlComponents.url else {
            completionHandler(nil, .malformedURL(message:""))
            return
        }
        var request = URLRequest(url: url)
        
        switch requestType {
        case .get:
            request.httpMethod = RequestType.get.rawValue
        case .post:
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .fragmentsAllowed)
                request.httpMethod = RequestType.post.rawValue

            }catch {
                completionHandler(nil, .malformedURL(message:""))
                return
            }
        }
        
        URLSession.shared.dataTask(with:request) {  (data, responce, error)  in
            guard  let _responce = responce as? HTTPURLResponse , _responce.statusCode == 200 else {
                completionHandler(nil, .errorWith(message: ""))
                return
            }
           
            guard let data = data, error == nil else {
                completionHandler(nil, .errorWith(message:""))
                return
            }
            
            completionHandler(data, nil)

        }.resume()
    }
}
