//
//  RootViewController.swift
//  chh-test-ios
//
//  Created by André Caçador on 19/6/18.
//  Copyright © 2018 André Caçador. All rights reserved.
//

import Foundation
import UIKit

class RootWireFrame: UIViewController, UIViewControllerInstaller {
    
    var rootTabBarController: KyndaTabBarController?

    init() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.chh_installChildViewController(current)
    }
    
    // MARK: Private
    
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
