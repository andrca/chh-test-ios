//
//  CoinListViewModel.swift
//  chh-test-ios
//
//  Created by André Caçador on 19/6/18.
//  Copyright © 2018 André Caçador. All rights reserved.
//

import Foundation
import ReactiveSwift
import BrightFutures

protocol UIRefresherProtocol {
    var refreshUISignal: MutableProperty<Bool> { get }
    
    func refreshData()
}


class CoinListViewModel: UIRefresherProtocol {
    
    //MARK: Public properties
    
    let refreshUISignal = MutableProperty<Bool>(false)
    var isLoading = MutableProperty<Bool>(false)
    let numberCoins = MutableProperty<Int>(0)
    let router: CoinListRouter
    
    // MARK: Private properties
    
    private let coinList = MutableProperty<[Coin]>([Coin]())
    private let coinRepository = CoinRepository()
    
    init(router: CoinListRouter) {
        self.router = router
        
        setupBindings()
        retrieveCoinList()
    }
    
    // MARK: Public methods
    
    func cellViewModelForIndexPath(_ indexPath: IndexPath) -> CoinListCellViewModel? {
        let coin = coinAt(indexPath)
        return CoinListCellViewModel(coin!)
    }
    
    func coinAt(_ indexPath: IndexPath) -> Coin? {
        guard let coin = coinList.value[indexPath.row] as Coin? else {
            print("[\(type(of: self))] \(#function) Out range (\(indexPath.row)) of coin with \(self.coinList.value.count) element/s")
            
            return nil
        }
        
        return coin
    }
    
    func refreshData() {
        retrieveCoinList()
    }
    
    // MARK: Actions
    
    func didSelectCoin(at indexPath: IndexPath) {
        guard let coin = self.coinAt(indexPath as IndexPath) as Coin? else {
            return
        }
        
        self.router.navigateToCoinDetails(coin: coin)
    }
    
    func didSelectPortfolio() {
        self.router.navigateToPortfolio()
    }
    
    // MARK: Private methods
    
    private func retrieveCoinList() {
        self.isLoading.value = true
        
        self.coinRepository.list(page: 0).onSuccess { (coins) in
            self.coinList.value = coins!.sorted(by: { $0.rank < $1.rank })
            
            }.onFailure { (error) in
                print("\(error)")
            }.onComplete { _ in
                self.isLoading.value = false
        }
    }
    
    private func setupBindings() {
        refreshUISignal <~ coinList.producer.map{ _ -> Bool in true }
        numberCoins <~ coinList.producer.map { $0.count }
    }
}
