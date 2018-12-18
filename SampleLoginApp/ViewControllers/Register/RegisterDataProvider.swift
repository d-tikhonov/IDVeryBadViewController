//
//  RegisterDataProvider.swift
//  SampleLoginApp
//
//  Created by Dmitry Tetenyuk on 17/12/2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

import Foundation

protocol RegisterDataProviderInput: class {
    func register(login:String, password:String)
}

protocol RegisterDataProviderOutput: class {
    func registrationFinished(error: Error?)
}

class RegisterDataProvider: RegisterDataProviderInput {

    public weak var output: RegisterDataProviderOutput?
    
    private init() {}
    
    init(output: RegisterDataProviderOutput) {
        self.output = output
    }
    
    func register(login: String, password: String) {
        let apiObject = APIObject(url: APIURL.register,
                                  method: .post,
                                  parameters: ["email": login, "password": password])
        
        NetWorker.shared.requestWithAPIObject(apiObject) { [weak self] (data, error) in
            guard let data = data, error == nil else {
                self?.output?.registrationFinished(error: error)
                return
            }
            do {
                guard (try JSONSerialization.jsonObject(with: data, options: [])
                    as? [String: Any]) != nil else {
                        print("error trying to convert data to JSON")
                        self?.output?.registrationFinished(error: error)
                        return
                }
                self?.output?.registrationFinished(error: nil)
            } catch {
                print("error trying to convert data to JSON")
                self?.output?.registrationFinished(error: error)
                return
            }
        }
    }
    
}

