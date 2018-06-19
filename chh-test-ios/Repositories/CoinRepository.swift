//
//  CoinRepository.swift
//  chh-test-ios
//
//  Created by André Caçador on 19/6/18.
//  Copyright © 2018 André Caçador. All rights reserved.
//

import Foundation
import RealmSwift
import BrightFutures
import ObjectMapper

class CoinRepository {
    lazy var apiDatasource = APIDataSource(networkMode: .network)
    
    func list(page: Int) -> Future<[Coin]?, NSError> {
        let coinAPI = CoinAPI.list(page: page)
        
        let request = APIRequest(resource: coinAPI)
        let requestFuture = self.apiDatasource.processRequest(request)
        let responsePromise = Promise<[Coin]?, NSError>()
        
        requestFuture.onSuccess(callback: { (json) in
            let node = request.resource.rootNode
            let coinsRootNode = json[node] as! JSON
            let coinsData = coinsRootNode["data"] as! [JSON]
            let coins = Mapper<Coin>().mapArray(JSONObject: coinsData)
            responsePromise.success(coins)
        }).onFailure { (error) in
            responsePromise.failure(error)
        }
        
        return responsePromise.future
    }
    
}

// MARK: - Coin API

enum CoinAPI {
    case list(page: Int)
}

extension CoinAPI: APIResource {
    
    var method: Method {
        switch self {
        case .list:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .list:
            return "/coins"
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .list(let page):
            return ["page": page]
        }
    }
    
    var rootNode: String {
        switch self {
        case .list:
            return "coins"
        }
    }
    
}
