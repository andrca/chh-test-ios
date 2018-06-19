//
//  APIRequest.swift
//  chh-test-ios
//
//  Created by André Caçador on 19/6/18.
//  Copyright © 2018 André Caçador. All rights reserved.
//

import Foundation

/**
 *  Specification for retrieve resource from Network API.
 */
struct APIRequest {
    let resource: APIResource
    
    init(resource: APIResource) {
        self.resource = resource
    }
}

/**
 *  Protocol to implement each API Request
 */
protocol APIResource {
    var method: Method { get }
    var path: String { get }
    var parameters: JSON? { get }
    var rootNode: String { get }
    var encoding: Encoding? { get }
}

extension APIRequest {
    
    /**
     Generate a NetworkRequest struct for this APIRequest
     
     - returns: NetworkRequest with this request data
     */
    func networkRequest() -> NetworkRequest {
        return NetworkRequest(path: self.resource.path, method: self.resource.method, parameters: self.parameters(), rootNode: self.resource.rootNode, encoding: self.resource.encoding)
    }
    
    
    // Private methods
    private func parameters() -> JSON? {
        guard let params = self.resource.parameters else {
            return nil
        }
        
        return params
    }
    
}

extension APIResource {
    
    var encoding: Encoding? {
        return .url
    }
}
