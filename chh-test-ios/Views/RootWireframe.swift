//
//  RootWireFrame.swift
//  chh-test-ios
//
//  Created by André Caçador on 19/6/18.
//  Copyright © 2018 André Caçador. All rights reserved.
//

import Foundation
import UIKit

class RootWireframe {
    
    var navigationController: UIViewController?

    init() {
        setupRootNavigationController()
    }
    
    // MARK: Private
    
    private func setupRootNavigationController() {
        navigationController = coinListNavigationController()
    }
    
    private func coinListNavigationController() -> UIViewController {
        let container = DefaultContainerController()
        let viewController = coinListViewController(in: container)
        container.set(viewController: viewController, animated: false)
        
        return container
    }
    
    // MARK: View Controllers
    
    private func coinListViewController(in container: Navigator) -> UIViewController {
        let router = CoinListRouter(container: container)
        let viewModel = CoinListViewModel(router: router)
        let viewController = CoinListViewController(viewModel: viewModel)
        
        return viewController
    }
}
