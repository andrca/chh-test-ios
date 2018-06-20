//
//  FloatExtension.swift
//  chh-test-ios
//
//  Created by André Caçador on 19/6/18.
//  Copyright © 2018 André Caçador. All rights reserved.
//

import Foundation

extension Float {
    
    func usdCurrencyFormat() -> String {
        return "$\(self.cleanValue)"
    }
    
    func toString() -> String {
        return String(format: "%.2f", self)
    }
    
    func toPercent() -> String {
        return "\(String(format: "%.2f", self))%"
    }
    
    var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.2f", self) : String(self)
    }
    
}
