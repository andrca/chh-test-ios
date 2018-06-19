//
//  AlamofireNetworkService.swift
//  chh-test-ios
//
//  Created by André Caçador on 19/6/18.
//  Copyright © 2018 André Caçador. All rights reserved.
//

import Foundation
import Alamofire
import BrightFutures

extension Method {
    
    /**
     Maps `NetworkService` to Alamofire's HTTP method definitions
     */
    func alamofireMethod() -> Alamofire.HTTPMethod {
        switch self {
        case .get: return .get
        case .post: return .post
        case .put: return .put
        case .delete: return .delete
        }
    }
    
}

class AlamofireNetworkService: NetworkService {
    
    let baseURL: URL

    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func processRequest(request: NetworkRequest) -> Future<NetworkResponse, NSError> {
        let promise = Promise<NetworkResponse, NSError>()

        guard let requestURL = URL(string: request.path, relativeTo: self.baseURL) else {
                // TODO: define error domain and codes for networking stack
                let error = NSError(domain: "", code: 0, userInfo: nil)
                promise.failure(error)
                
                return promise.future
        }
        
        var httpHeaders = ["Content-Type" : "application/json"]
        let dataManager = DataManager()
        let token = dataManager.getSecure(.authentication)
        if let token = token {
            httpHeaders["Authorization"] = token
        }
        
        let alamofireRequest = Alamofire.request(
            requestURL.absoluteString,
            method: request.method.alamofireMethod(),
            parameters: request.parameters,
            encoding: JSONEncoding.default,
            headers: httpHeaders)
        
        alamofireRequest.validate().responseJSON { (response) -> Void in
            switch response.result {
            case .success(let value):
                let networkResponse = NetworkResponse(
                    originalRequest: request,
                    statusCode: response.response!.statusCode,
                    responseObject: (value as! JSON))
                promise.success(networkResponse)
            case .failure(let error):
                let responseError = error as NSError
                promise.failure(responseError)
            }
        }
        
        return promise.future
    }
    
}
