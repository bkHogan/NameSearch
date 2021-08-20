//
//  BaseRepository.swift
//  NameSearch
//
//  Created by MAC on 20/08/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation

typealias Completion<T:Decodable> =  ((Result<T, NetworkError>) -> Void)

class BaseRepository {
    var networkManager:Networkable

    init(networkManager:Networkable = NetworkManager()) {
        self.networkManager = networkManager
    }
}
