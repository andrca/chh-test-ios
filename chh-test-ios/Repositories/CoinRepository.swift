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
import Realm

class CoinRepository {
    lazy var apiDatasource = APIDataSource(networkMode: .network)
    
    // MARK: Public methods
    
    func list(page: Int) -> Future<[Coin]?, NSError> {
        let coinAPI = CoinAPI.list(page: page)
        
        let request = APIRequest(resource: coinAPI)
        let requestFuture = self.apiDatasource.processRequest(request)
        let responsePromise = Promise<[Coin]?, NSError>()
        
        requestFuture.onSuccess(callback: { (json) in
            let node = request.resource.rootNode
            let coinsRootNode = json[node] as! JSON
            let coinsJSONData = coinsRootNode["data"] as! [JSON]
            let coins = Mapper<Coin>().mapArray(JSONObject: coinsJSONData)
            self.saveCoinListToStore(coins!)
            
            responsePromise.success(coins)
        }).onFailure { (error) in
            let store = self.retrieveCoinListFromStore()
            guard let error = store.error else {
                responsePromise.success(store.coinList)
                return
            }
            
            responsePromise.failure(error)
        }
        
        return responsePromise.future
    }
    
    func historical(coinId: Int) -> Future<[Historical]?, NSError> {
        let coinAPI = CoinAPI.historical(coinId: coinId)
        
        let request = APIRequest(resource: coinAPI)
        let requestFuture = self.apiDatasource.processRequest(request)
        let responsePromise = Promise<[Historical]?, NSError>()
        
        requestFuture.onSuccess(callback: { (json) in
            let node = request.resource.rootNode
            let historicalJSONData = json[node] as! [JSON]
            let historicalList = Mapper<Historical>().mapArray(JSONObject: historicalJSONData)
            historicalList?.forEach({ (h) in
                h.coinId = coinId
            })
            self.saveHistoricalListToStore(coinId: coinId, historicalList: historicalList!)

            responsePromise.success(historicalList)
        }).onFailure { (error) in
            let store = self.retrieveHistoricalListFromStore(coinId: coinId)
            guard let error = store.error else {
                responsePromise.success(store.historicalList)
                return
            }
            
            responsePromise.failure(error)
        }
        
        return responsePromise.future
    }
    
    // MARK: Private methods
    
    private func retrieveCoinListFromStore() -> (coinList: [Coin], error: NSError?) {
        do {
            let realm = try Realm()
            let coins = realm.objects(Coin.self)
            return (Array(coins), nil)
        } catch let error as NSError {
            print("\(error)")
            return ([], error)
        }
    }
    
    private func saveCoinListToStore(_ coins: [Coin]) {
        do {
            let realm = try Realm()
            try realm.write {
                for coin in coins {
                    realm.add(coin, update: true)
                }
            }
        } catch let error as NSError {
            print("\(error)")
        }
    }
    
    private func retrieveHistoricalListFromStore(coinId: Int) -> (historicalList: [Historical], error: NSError?) {
        do {
            let realm = try Realm()
            let historical = realm.objects(Historical.self).filter("coinId = \(coinId)")
            return (Array(historical), nil)
        } catch let error as NSError {
            print("\(error)")
            return ([], error)
        }
    }
    
    private func saveHistoricalListToStore(coinId: Int, historicalList: [Historical]) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(realm.objects(Historical.self).filter("coinId = \(coinId)"))
                for historical in historicalList {
                    realm.add(historical)
                }
            }
        } catch let error as NSError {
            print("\(error)")
        }
    }
    
}

// MARK: - Coin API

enum CoinAPI {
    case list(page: Int)
    case historical(coinId: Int)
}

extension CoinAPI: APIResource {
    
    var method: Method {
        switch self {
        case .list:
            return .get
        case .historical:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .list:
            return "/coins"
        case .historical(let coinId):
            return "/coins/\(coinId)/historical"
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .list(let page):
            return ["page": page]
        default:
            return nil
        }
    }
    
    var rootNode: String {
        switch self {
        case .list:
            return "coins"
        case .historical:
            return "historical"
        }
    }
    
}
