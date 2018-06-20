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
            self.saveOrUpdateCoinListInStore(coins!)
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
    
    func get(coinId: Int) -> Future<Coin?, NSError> {
        let coinAPI = CoinAPI.get(coinId: coinId)
        
        let request = APIRequest(resource: coinAPI)
        let requestFuture = self.apiDatasource.processRequest(request)
        let responsePromise = Promise<Coin?, NSError>()
        
        requestFuture.onSuccess(callback: { (json) in
            let node = request.resource.rootNode
            let coinJSONData = json[node] as! JSON
            let coin = Mapper<Coin>().map(JSONObject: coinJSONData)
            self.saveOrUpdateCoinInStore(coin!)
            responsePromise.success(coin)
        }).onFailure { (error) in
            let store = self.retrieveCoinFromStore(coinId)
            if let coin = store.coin {
                responsePromise.success(coin)
                return
            }
            
            if let err = store.error {
                responsePromise.failure(err)
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
            self.saveOrUpdateHistoricalListInStore(coinId: coinId, historicalList: historicalList!)
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
    
    func portfolio() -> Future<[GroupedTrades]?, NSError> {
        let coinAPI = CoinAPI.portfolio()
        
        let request = APIRequest(resource: coinAPI)
        let requestFuture = self.apiDatasource.processRequest(request)
        let responsePromise = Promise<[GroupedTrades]?, NSError>()
        
        requestFuture.onSuccess(callback: { (json) in
            let node = request.resource.rootNode
            let groupedTradesJSONData = json[node] as! [JSON]
            let groupedTrades = Mapper<GroupedTrades>().mapArray(JSONObject: groupedTradesJSONData)
            
            var coinSequence: [Future<JSON, NSError>] = []
            groupedTrades?.forEach({ gT in
                let coinAPI = CoinAPI.get(coinId: gT.coinId)
                let request = APIRequest(resource: coinAPI)
                let requestFuture = self.apiDatasource.processRequest(request)
                coinSequence.append(requestFuture)
            })
            
            coinSequence.sequence().onSuccess { results in
                let coinsJSONData = results.flatMap({ json -> [JSON] in
                    let coinJSONData = json["coin"] as! JSON
                    return [coinJSONData]
                })
    
                let coins = Mapper<Coin>().mapArray(JSONArray: coinsJSONData)
                
                groupedTrades?.forEach({ gt in
                    do {
                        let realm = try Realm()
                        try realm.write {
                            gt.coin = coins.filter { $0.id == gt.coinId }.first
                        }
                    } catch let error as NSError {
                        print("\(error)")
                    }
                })
                self.saveOrUpdateGroupedTradesInStore(groupedTrades!)
                responsePromise.success(groupedTrades)
            }
            
        }).onFailure { (error) in
            let store = self.retrieveGroupedTradesFromStore()
            guard let error = store.error else {
                responsePromise.success(store.groupedTrades)
                return
            }
            
            responsePromise.failure(error)
        }
        
        return responsePromise.future
    }
    
    func newTrade(trade: Trade) -> Future<Trade?, NSError> {
        let coinAPI = CoinAPI.newTrade(trade: trade)
        
        let request = APIRequest(resource: coinAPI)
        let requestFuture = self.apiDatasource.processRequest(request)
        let responsePromise = Promise<Trade?, NSError>()
        
        requestFuture.onSuccess(callback: { (json) in
            let node = request.resource.rootNode
            let tradeJSONData = json[node] as! JSON
            let trade = Mapper<Trade>().map(JSONObject: tradeJSONData)
            responsePromise.success(trade)
        }).onFailure { (error) in
            responsePromise.failure(error)
        }
        
        return responsePromise.future
    }
    
    // MARK: Private methods
    
    private func retrieveCoinFromStore(_ id: Int) -> (coin: Coin?, error: NSError?) {
        do {
            let realm = try Realm()
            let coin = realm.objects(Coin.self).filter("id = \(id)").first
            return (coin, nil)
        } catch let error as NSError {
            print("\(error)")
            return (nil, error)
        }
    }
    
    private func saveOrUpdateCoinInStore(_ coin: Coin) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(coin, update: true)
            }
        } catch let error as NSError {
            print("\(error)")
        }
    }
    
    private func retrieveCoinListFromStore() -> (coinList: [Coin], error: NSError?) {
        do {
            let realm = try Realm()
            let coins = Array(realm.objects(Coin.self))
            return (coins, nil)
        } catch let error as NSError {
            print("\(error)")
            return ([], error)
        }
    }
    
    private func saveOrUpdateCoinListInStore(_ coins: [Coin]) {
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
            let historical = Array(realm.objects(Historical.self).filter("coinId = \(coinId)"))
            return (historical, nil)
        } catch let error as NSError {
            print("\(error)")
            return ([], error)
        }
    }
    
    private func saveOrUpdateHistoricalListInStore(coinId: Int, historicalList: [Historical]) {
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
    
    private func retrieveGroupedTradesFromStore() -> (groupedTrades: [GroupedTrades], error: NSError?) {
        do {
            let realm = try Realm()
            let groupedTrades = Array(realm.objects(GroupedTrades.self))
            return (groupedTrades, nil)
        } catch let error as NSError {
            print("\(error)")
            return ([], error)
        }
    }
    
    private func saveOrUpdateGroupedTradesInStore(_ groupedTrades: [GroupedTrades]) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(realm.objects(GroupedTrades.self))
                for trade in groupedTrades {
                    realm.add(trade, update: true)
                }
            }
        } catch let error as NSError {
            print("\(error)")
        }
    }
    
}

// MARK: - Coin API

enum CoinAPI {
    case get(coinId: Int)
    case list(page: Int)
    case historical(coinId: Int)
    case portfolio()
    case newTrade(trade: Trade)
}

extension CoinAPI: APIResource {
    
    var method: Method {
        switch self {
        case .get, .list, .historical, .portfolio:
            return .get
        case .newTrade:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .get(let coinId):
            return "/coins/\(coinId)"
        case .list:
            return "/coins"
        case .historical(let coinId):
            return "/coins/\(coinId)/historical"
        case .portfolio, .newTrade:
            return "/portfolio"
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .list(let page):
            return ["page": page]
        case .newTrade(let trade):
            return trade.toJSON()
        default:
            return nil
        }
    }
    
    var rootNode: String {
        switch self {
        case .get:
            return "coin"
        case .list, .portfolio:
            return "coins"
        case .historical:
            return "historical"
        case .newTrade:
            return "trade"
        }
    }
    
}
