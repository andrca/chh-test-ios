//
//  CoinListRouter.swift
//  chh-test-ios
//
//  Created by André Caçador on 19/6/18.
//  Copyright © 2018 André Caçador. All rights reserved.
//

import Foundation
import UIKit

class CoinListRouter {
    
    let container: Navigator
    
    init(container: Navigator) {
        self.container = container
    }
    
    func navigateToCoinDetails(coin: Coin) {
        let router = CoinDetailRouter(container: container)
        let viewModel = CoinDetailViewModel(router: router, coin: coin)
        let viewController = CoinDetailViewController(viewModel: viewModel)
        
        container.push(viewController: viewController, animated: true)
    }
    
    func navigateToPortfolio() {
        let router = PortfolioListRouter(container: container)
        let viewModel = PortfolioListViewModel(router: router)
        let viewController = PortfolioListViewController(viewModel: viewModel)
        
        container.push(viewController: viewController, animated: true)
    }
}
