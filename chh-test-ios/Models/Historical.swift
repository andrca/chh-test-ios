//
//  Historical.swift
//  chh-test-ios
//
//  Created by André Caçador on 19/6/18.
//  Copyright © 2018 André Caçador. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Historical: Object, Mappable {
    @objc dynamic var coinId = 0
    @objc dynamic var priceUsd: Double = 0
    @objc dynamic var snapshotAt = Date()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        let transformDate = TransformOf<Date, String>(fromJSON: { (value: String?) -> Date? in
            return DateFormatter.iso8601.date(from: value!)
        }, toJSON: { (value: Date?) -> String? in
            return value!.iso8601
        })
        
        coinId     <- map["id"]
        priceUsd   <- (map["price_usd"], JSONStringToDoubleTransform())
        snapshotAt <- (map["snapshot_at"], transformDate)
    }
    
}

class JSONStringToDoubleTransform: TransformType {
    
    typealias Object = Double
    typealias JSON = String
    
    init() {}
    func transformFromJSON(_ value: Any?) -> Double? {
        if let strValue = value as? String {
            return Double(strValue)
        }
        return value as? Double ?? nil
    }
    
    func transformToJSON(_ value: Double?) -> String? {
        if let doubleValue = value {
            return "\(doubleValue)"
        }
        return nil
    }
}
