//
//  EndPointDetails.swift
//  NameSearch
//
//  Created by MAC on 19/08/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation


enum EndPoint {
    static let baseUrl = "https://gd.proxied.io"
}

enum APIPath:String {
    case login = "/auth/login"
    case searchExact = "/search/exact"
    case searchSpins = "/search/spins"
    case payment = "/payments/process"
    case paymentMethods = "/user/payment-methods"
}
