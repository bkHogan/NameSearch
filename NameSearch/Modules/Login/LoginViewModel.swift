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
    
    var repository:LoginRepositoryType
    weak var loginView:LoginViewType?
    
    init(repository:LoginRepositoryType = LoginRepository(), loginView:LoginViewType) {
        self.repository = repository
        self.loginView = loginView
    }
    
    func login(userName: String, password: String) {
        repository.login(userName: userName, password: password, modelType: LoginResponse.self) { [weak self] result  in
            switch result {
            case .success(let response):
                AuthManager.shared.user = response.user
                AuthManager.shared.token = response.auth.token
                self?.loginView?.updateUI()
            case .failure(let error):
                AuthManager.shared.user = nil
                AuthManager.shared.token = nil
                self?.loginView?.showError()
            }
        }
    }
}
