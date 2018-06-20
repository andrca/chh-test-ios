//
//  GroupedTrades.swift
//  chh-test-ios
//
//  Created by André Caçador on 20/6/18.
//  Copyright © 2018 André Caçador. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class GroupedTrades: Object, Mappable {
    @objc dynamic var coinId = 0
    @objc dynamic var amount: Float = 0
    @objc dynamic var priceUsd: Float = 0
    @objc dynamic var coin: Coin?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        coinId    <- map["coin_id"]
        amount    <- (map["amount"], JSONStringToFloatTransform())
        priceUsd  <- (map["price_usd"], JSONStringToFloatTransform())
    }
    
    override static func primaryKey() -> String? {
        return "coinId"
    }
}
