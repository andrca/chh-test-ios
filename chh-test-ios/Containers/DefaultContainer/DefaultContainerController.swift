//
//  DefaultContainerController.swift
//  chh-test-ios
//
//  Created by André Caçador on 19/6/18.
//  Copyright © 2018 André Caçador. All rights reserved.
//

import Foundation
import UIKit

class DefaultContainerController: UIViewController, UIViewControllerInstaller {
    
    // MARK: Private properties
    
    fileprivate lazy var defaultNavigationController = DefaultNavigationController()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.chh_installChildViewController(defaultNavigationController)
    }
    
}

extension DefaultContainerController: Navigator {
    
    func push(viewController: UIViewController, animated: Bool) {
        self.defaultNavigationController.pushViewController(viewController, animated: animated)
    }
    
    func set(viewController: UIViewController, animated: Bool) {
        self.defaultNavigationController.setViewControllers([viewController], animated: animated)
    }
    
    func popViewController(animated: Bool) {
        self.defaultNavigationController.popViewController(animated: animated)
    }
    
    func present(viewController: UIViewController, animated: Bool) {
        self.present(viewController, animated: animated, completion: nil)
    }
    
    func popToRootViewController(animated: Bool) {
        self.dismiss(animated: animated, completion: nil)
    }
    
}

protocol Navigator {
    func push(viewController: UIViewController, animated: Bool)
    func set(viewController: UIViewController, animated: Bool)
    func present(viewController: UIViewController, animated: Bool)
    func popToRootViewController(animated: Bool)
    func popViewController(animated: Bool)
}

