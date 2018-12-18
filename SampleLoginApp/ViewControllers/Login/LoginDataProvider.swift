//
//  LoginDataProvider.swift
//  SampleLoginApp
//
//  Created by Dmitry Tetenyuk on 17/12/2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

import Foundation

protocol LoginDataProviderInput: class {
    func login(login:String, password:String)
}

protocol LoginDataProviderOutput: class {
    func loginFinished(error: Error?)
}

class LoginDataProvider: LoginDataProviderInput {
    
    public weak var output: LoginDataProviderOutput?
    
    private init() {}
    
    init(output: LoginDataProviderOutput) {
        self.output = output
    }
    
    func login(login: String, password: String) {
        let apiObject = APIObject(url: APIURL.login,
                                  method: .post,
                                  parameters: ["email": login, "password": password])
        
        NetWorker.shared.requestWithAPIObject(apiObject) { [weak self] (data, error) in
            guard let data = data, error == nil else {
                self?.output?.loginFinished(error: error)
                return
            }
            do {
                guard (try JSONSerialization.jsonObject(with: data, options: [])
                    as? [String: Any]) != nil else {
                        print("error trying to convert data to JSON")
                        self?.output?.loginFinished(error: error)
                        return
                }
                self?.output?.loginFinished(error: nil)
            } catch {
                print("error trying to convert data to JSON")
                self?.output?.loginFinished(error: error)
                return
            }
        }
    }
    
}
