//
//  APIDataSource.swift
//  chh-test-ios
//
//  Created by André Caçador on 19/6/18.
//  Copyright © 2018 André Caçador. All rights reserved.
//

import Foundation
import BrightFutures

/**
 The network layer has two modes of operation:
 
 - Network:  Using real calls to WS (default mode)
 - Fixtures: Using local sets of tests
 */
enum APIDataSourceMode {
    case network
    // TODO: case fixtures
}

// Interface of network layer
class APIDataSource {
    
    let networkService: NetworkService
    
    init(networkMode: APIDataSourceMode = .network) {
        switch networkMode {
        case .network:
            let url = URL(string: Configuration.sharedInstance.apiEndpoint())
            
            self.networkService = AlamofireNetworkService(baseURL: url!)
        }
    }
    
    func processRequest(_ request: APIRequest) -> Future<JSON, NSError> {
        let networkRequest = request.networkRequest()
        let requestFuture = self.networkService.processRequest(request: networkRequest)
        let responsePromise = Promise<JSON, NSError>()
        
        requestFuture.onSuccess { (networkResponse) in
            guard let json = networkResponse.responseObject else {
                return
            }
            
            responsePromise.success(json)
            }.onFailure { (error) in
                responsePromise.failure(error)
        }
        
        return responsePromise.future
    }
    
}
