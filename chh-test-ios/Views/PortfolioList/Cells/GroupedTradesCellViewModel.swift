//
//  GroupedTradesCellViewModel.swift
//  chh-test-ios
//
//  Created by André Caçador on 20/6/18.
//  Copyright © 2018 André Caçador. All rights reserved.
//

import Foundation
import ReactiveSwift

class GroupedTradesCellViewModel {
    
    // MARK: Public properties
    
    let coinName = MutableProperty<String>("")
    let amount = MutableProperty<String>("")
    let priceUsd = MutableProperty<String>("")
    
    // MARK: Private properties
    
    private let groupedTrades: MutableProperty<GroupedTrades>
    
    init(_ groupedTrades: GroupedTrades) {
        self.groupedTrades = MutableProperty(groupedTrades)
        
        setupBindings()
    }
    
    // MARK: Private properties
    
    private func setupBindings() {
        self.coinName <~ self.groupedTrades.producer.map { $0.coin!.name }
        self.amount <~ self.groupedTrades.producer.map { $0.amount.toString() + " " + $0.coin!.symbol }
        self.priceUsd <~ self.groupedTrades.producer.map { $0.priceUsd.usdCurrencyFormat() }
    }
    
}

