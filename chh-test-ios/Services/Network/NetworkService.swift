//
//  NetworkService.swift
//  chh-test-ios
//
//  Created by André Caçador on 19/6/18.
//  Copyright © 2018 André Caçador. All rights reserved.
//

import Foundation
import BrightFutures

public typealias JSON = [String : Any]

protocol NetworkService {
    func processRequest(request: NetworkRequest) -> Future<NetworkResponse, NSError>
}

/**
 Verbs supported by the API
 
 - get:    The 'get' method requests a representation of the specified resource.
 - post:   The 'post' method requests that the server accept the entity enclosed in the request as a new subordinate of the web resource identified by the URI.
 - put:    The 'put' method requests that the enclosed entity be stored under the supplied URI.
 - delete: The 'delete' method deletes the specified resource.
 */
public enum Method: String {
    case get
    case post
    case put
    case delete
}

public enum Encoding {
    case url
    case urlEncodedInURL
    case json
}

/**
 *  The structure that must have any request to network
 */
struct NetworkRequest {
    let path: String
    let method: Method
    let parameters: JSON?
    let rootNode: String
    let encoding: Encoding?
}

/**
 *  Serialization of a response of network
 */
struct NetworkResponse {
    let originalRequest: NetworkRequest
    let statusCode: Int
    let responseObject: JSON?
}
