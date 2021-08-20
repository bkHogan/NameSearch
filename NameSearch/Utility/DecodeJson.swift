//
//  DecodeJson.swift
//  NameSearch
//
//  Created by MAC on 20/08/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation

protocol DecodeJson {
    func decodeObject<T:Decodable>(input:Data, type:T.Type)-> T?
    func decodeArray<T:Decodable>(input:Data, type:T.Type)-> [T]?
}

extension DecodeJson {
    func decodeObject<T:Decodable>(input:Data, type:T.Type)-> T? {
        return  try? JSONDecoder().decode(T.self, from: input)
    }
    func decodeArray<T:Decodable>(input:Data, type:T.Type)-> [T]? {
        return  try? JSONDecoder().decode([T].self, from: input)
    }
}
