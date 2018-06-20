//
//  Coin.swift
//  chh-test-ios
//
//  Created by André Caçador on 19/6/18.
//  Copyright © 2018 André Caçador. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Coin: Object, Mappable {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var symbol = ""
    @objc dynamic var logo: String? = nil
    @objc dynamic var rank = 0
    @objc dynamic var priceUsd: Float = 0
    @objc dynamic var priceBtc: Float = 0
    @objc dynamic var twentyFourHVolumeUsd: Int = 0
    @objc dynamic var marketCapUsd: Int = 0
    @objc dynamic var availableSupply: Int = 0
    @objc dynamic var totalSupply: Int = 0
    @objc dynamic var percentChangeOneH: Float = 0
    @objc dynamic var percentChangeTwentyFourH: Float = 0
    @objc dynamic var percentChangeSevenDays: Float = 0
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
        
        id                       <- map["id"]
        name                     <- map["name"]
        symbol                   <- map["symbol"]
        logo                     <- map["logo"]
        rank                     <- map["rank"]
        priceUsd                 <- (map["price_usd"], JSONStringToFloatTransform())
        priceBtc                 <- (map["price_btc"], JSONStringToFloatTransform())
        twentyFourHVolumeUsd     <- map["24h_volume_usd"]
        marketCapUsd             <- map["market_cap_usd"]
        availableSupply          <- map["available_supply"]
        totalSupply              <- map["total_supply"]
        percentChangeOneH        <- (map["percent_change_1h"], JSONStringToFloatTransform())
        percentChangeTwentyFourH <- (map["percent_change_24h"], JSONStringToFloatTransform())
        percentChangeSevenDays   <- (map["percent_change_7d"], JSONStringToFloatTransform())
        createdAt                <- (map["created_at"], transformDate)
        updatedAt                <- (map["updated_at"], transformDate)
    }

    override static func primaryKey() -> String? {
        return "id"
    }
    
}

class JSONStringToFloatTransform: TransformType {
    
    init() {}
    func transformFromJSON(_ value: Any?) -> Float? {
        if let strValue = value as? String {
            return Float(strValue)
        }
        return value as? Float ?? nil
    }
    
    func transformToJSON(_ value: Float?) -> String? {
        if let floatValue = value {
            return "\(floatValue)"
        }
        return nil
    }
}
