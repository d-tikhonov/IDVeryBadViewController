//
//  APIURL.swift
//  SampleLoginApp
//
//  Created by Dmitry Tetenyuk on 14/12/2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

import Foundation

class APIURL {
    static var login: URL {
        return URL(string: "https://reqres.in/api/login")!
    }
    
    static var register: URL {
        return URL(string: "https://reqres.in/api/register")!
    }
    
    static var profile: URL {
        return URL(string: "https://reqres.in/api/users/1")!
    }
}
