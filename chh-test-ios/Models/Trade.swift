//
//  Trade.swift
//  chh-test-ios
//
//  Created by André Caçador on 20/6/18.
//  Copyright © 2018 André Caçador. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Trade: Object, Mappable {
    @objc dynamic var id = 0
    @objc dynamic var coinId = 0
    @objc dynamic var userId = 0
    @objc dynamic var amount: Float = 0
    @objc dynamic var priceUsd: Float = 0
    @objc dynamic var totalUsd: Float = 0
    @objc dynamic var notes: String? = nil
    @objc dynamic var tradedAt = Date()
    @objc dynamic var createdAt = Date()
    @objc dynamic var updatedAt = Date()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        let transformDate = TransformOf<Date, String>(fromJSON: { (value: String?) -> Date? in
            return DateFormatter.iso8601.date(from: value!)
        }, toJSON: { (value: Date?) -> String? in
            return value!.iso8601
        })
        
        id        <- map["id"]
        coinId    <- map["coin_id"]
        userId    <- map["user_id"]
        amount    <- map["amount"]
        priceUsd  <- (map["price_usd"], JSONStringToFloatTransform())
        totalUsd  <- (map["total_usd"], JSONStringToFloatTransform())
        notes     <- map["notes"]
        tradedAt  <- (map["traded_at"], transformDate)
        createdAt <- (map["created_at"], transformDate)
        updatedAt <- (map["updated_at"], transformDate)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
