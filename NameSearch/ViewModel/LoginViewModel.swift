//
//  LoginViewModel.swift
//  NameSearch
//
//  Created by MAC on 19/08/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation


protocol LoginType {
    func login(userName:String, password:String)
}

class LoginViewModel: LoginType {
    
    var networkManager:Networkable
    weak var loginView:LoginViewType?
    
    init(networkManager:Networkable = NetworkManager(), loginView:LoginViewType) {
        self.networkManager = networkManager
        self.loginView = loginView
    }
    
    func login(userName: String, password: String) {
        networkManager.post(baseUrl:EndPoint.baseUrl, path:APIPath.login.rawValue, params: [:], type:LoginResponse.self) { [weak self] result  in
            switch result {
            case .success(let response):
                AuthManager.shared.user = response.user
                AuthManager.shared.token = response.auth.token
                self?.loginView?.updateUI()
            case .failure(let error):
                print(error)
            }
        }
    }
}
