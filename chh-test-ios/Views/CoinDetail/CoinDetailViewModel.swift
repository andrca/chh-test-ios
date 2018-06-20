//
//  CoinDetailViewModel.swift
//  chh-test-ios
//
//  Created by André Caçador on 19/6/18.
//  Copyright © 2018 André Caçador. All rights reserved.
//

import Foundation
import ReactiveSwift

class CoinDetailViewModel {
    
    // MARK: Public properties
    
    let router: CoinDetailRouter
    var isLoading = MutableProperty<Bool>(false)
    let coinName = MutableProperty<String>("")
    let coinPriceUsd = MutableProperty<String>("")
    let coinMarketCapUsd = MutableProperty<String>("")
    let coinVariation = MutableProperty<String>("")
    let orderedHistoricalList = MutableProperty<[Historical]>([Historical]())

    // MARK: Private properties
    
    private let historicalList = MutableProperty<[Historical]>([Historical]())
    private let coin: MutableProperty<Coin>
    private let coinRepository = CoinRepository()
    
    init(router: CoinDetailRouter, coin: Coin) {
        self.router = router
        self.coin = MutableProperty(coin)
        
        setupBindings()
        retrieveCoinHistorical(coin.id)
    }
    
    // MARK: Private methods
    
    private func retrieveCoinHistorical(_ coinId: Int) {
        self.isLoading.value = true
        
        self.coinRepository.historical(coinId: coinId).onSuccess { (historical) in
            self.historicalList.value = historical!
            self.orderedHistoricalList.value = historical!.sorted(by: { $0.snapshotAt.compare($1.snapshotAt) == .orderedDescending })
            }.onFailure { (error) in
                print("\(error)")
            }.onComplete { _ in
                self.isLoading.value = false
        }
        
    }
    
    private func setupBindings() {
        self.coin.producer.startWithValues { [weak self] coin in
            guard let strongSelf = self else { return }
            
            strongSelf.coinName.value = coin.name
            strongSelf.coinPriceUsd.value = coin.priceUsd.usdCurrencyFormat()
            strongSelf.coinMarketCapUsd.value = "Market Cap: $\(coin.marketCapUsd)"
            strongSelf.coinVariation.value = "Variation: \(coin.percentChangeSevenDays.toPercent()) this week"
        }
    }

}
