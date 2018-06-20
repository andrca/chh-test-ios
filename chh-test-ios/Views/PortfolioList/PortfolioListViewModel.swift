//
//  PortfolioListViewModel.swift
//  chh-test-ios
//
//  Created by André Caçador on 20/6/18.
//  Copyright © 2018 André Caçador. All rights reserved.
//

import Foundation
import ReactiveSwift

class PortfolioListViewModel: UIRefresherProtocol {
    
    let refreshUISignal = MutableProperty<Bool>(false)
    var isLoading = MutableProperty<Bool>(false)
    let numberGroupedTrades = MutableProperty<Int>(0)
    let router: PortfolioListRouter
    
    // MARK: Private properties
    
    private let groupedTradesList = MutableProperty<[GroupedTrades]>([GroupedTrades]())
    private let coinRepository = CoinRepository()
    
    init(router: PortfolioListRouter) {
        self.router = router
        
        setupBindings()
        retrieveGroupedTradesList()
    }
    
    // MARK: Public methods
    
    func cellViewModelForIndexPath(_ indexPath: IndexPath) -> GroupedTradesCellViewModel? {
        let gTrades = groupedTradeAt(indexPath)
        return GroupedTradesCellViewModel(gTrades!)
    }
    
    func groupedTradeAt(_ indexPath: IndexPath) -> GroupedTrades? {
        guard let gTrades = groupedTradesList.value[indexPath.row] as GroupedTrades? else {
            print("[\(type(of: self))] \(#function) Out range (\(indexPath.row)) of coin with \(self.groupedTradesList.value.count) element/s")
            
            return nil
        }
        
        return gTrades
    }
    
    func refreshData() {
        retrieveGroupedTradesList()
    }
    
    // MARK: Private methods
    
    private func retrieveGroupedTradesList() {
        self.isLoading.value = true
        
        self.coinRepository.portfolio()
            .onSuccess { (groupedTrades) in
                self.groupedTradesList.value = groupedTrades!
            }.onFailure { (error) in
                print("\(error)")
            }.onComplete { _ in
                self.isLoading.value = false
        }
    }
    
    private func setupBindings() {
        refreshUISignal <~ groupedTradesList.producer.map{ _ -> Bool in true }
        numberGroupedTrades <~ groupedTradesList.producer.map { $0.count }
    }
    
}
