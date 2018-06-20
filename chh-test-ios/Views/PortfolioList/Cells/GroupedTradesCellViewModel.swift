//
//  TradeCellViewModel.swift
//  chh-test-ios
//
//  Created by André Caçador on 20/6/18.
//  Copyright © 2018 André Caçador. All rights reserved.
//

import Foundation
import ReactiveSwift

class GroupedTradeCellViewModel {
    
    // MARK: Public properties
    
    let name = MutableProperty<String>("")
    let symbol = MutableProperty<String>("")
    let currentPrice = MutableProperty<String>("")
    let percentageChange = MutableProperty<String>("")
    
    // MARK: Private properties
    
    private let coin: MutableProperty<Coin>
    
    init(_ groupedTrades: GroupedTrades) {
        self.coin = MutableProperty(coin)
        
        setupBindings()
    }
    
    // MARK: Private properties
    
    private func setupBindings() {
        self.name <~ self.coin.producer.map { $0.name }
        self.symbol <~ self.coin.producer.map { $0.symbol }
        self.currentPrice <~ self.coin.producer.map { $0.priceUsd.usdCurrencyFormat() }
        self.percentageChange <~ self.coin.producer.map { String($0.percentChangeOneH.toPercent()) }
    }
    
}

