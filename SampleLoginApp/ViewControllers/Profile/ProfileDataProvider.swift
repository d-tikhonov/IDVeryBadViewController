//
//  ProfileDataProvider.swift
//  SampleLoginApp
//
//  Created by Dmitry Tetenyuk on 17/12/2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

import Foundation

protocol ProfileDataProviderInput: class {
    func requestUser()
}

protocol ProfileDataProviderOutput: class {
    func loadingFinished(user:User?, error:Error?)
}

class ProfileDataProvider: ProfileDataProviderInput {
    public weak var output: ProfileDataProviderOutput?
    
    init(output: ProfileDataProviderOutput) {
        self.output = output
    }
    
    private init() {}
    
    func requestUser() {
        let apiObject = APIObject(url: APIURL.profile,
                                  method: .get,
                                  parameters: nil)
        
        NetWorker.shared.requestWithAPIObject(apiObject) { [weak self] (data, error) in
            guard let data = data, error == nil else {
                self?.output?.loadingFinished(user: nil, error: error)
                return
            }
            do {
                guard let data = try JSONSerialization.jsonObject(with: data, options: [])
                    as? [String: [String:Any]] else {
                        return
                }
                let truedict = data["data"]!
                let user = User(firstName: truedict["first_name"] as! String, lastName: truedict["last_name"] as! String, avatarURL: truedict["avatar"] as! String)
                self?.output?.loadingFinished(user: user, error: nil)
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
    }
}

