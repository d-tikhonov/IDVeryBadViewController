//
//  NetWorker.swift
//  SampleLoginApp
//
//  Created by Dmitry Tetenyuk on 14/12/2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

class APIObject {
    var parameters: [String : Any]? = nil
    var method: HTTPMethod = .get
    var url: URL
    
    init(url:URL, method:HTTPMethod, parameters:[String:Any]? = nil) {
        self.method = method
        self.url = url
        self.parameters = parameters
    }
    
    private func parametersToData(parameters: [String : Any]?) -> Data? {
        guard let parameters = parameters else {
            return nil
        }
        let jsonData: Data
        do {
            jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Error: cannot create JSON from todo")
            return nil
        }
        return jsonData
    }
    
    public func buildRequest() -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10)
        request.httpMethod = method.rawValue
        request.httpBody = parametersToData(parameters: parameters)
        return request
    }
    
}


class NetWorker {
    public static let shared = NetWorker()
    
    private var session: URLSession {
        return URLSession(configuration: .default)
    }
    
    public func requestWithAPIObject(_ apiObject:APIObject, completion:@escaping (Data?, Error?) -> Void) {
        let session = self.session
        let task = session.dataTask(with: apiObject.buildRequest()) {
            (data, response, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            guard let responseData = data else {
                completion(nil, nil)
                return
            }
            completion(responseData, nil)
        }
        task.resume()
    }
    
    private init() { }
}

