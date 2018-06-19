//
//  ViewControllerExtension.swift
//  chh-test-ios
//
//  Created by André Caçador on 19/6/18.
//  Copyright © 2018 André Caçador. All rights reserved.
//

import Foundation
import UIKit

protocol UIViewControllerInstaller {}

extension UIViewControllerInstaller where Self: UIViewController {
    
    /**
     * Installs a view controller inside another one (self)
     * @param viewController The view controller which is being added as a child view controller of self
     */
    func chh_installChildViewController(_ viewController: UIViewController) {
        addChildViewController(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParentViewController: self)
    }

    /**
     * Uninstalls a view controller which is inside another one (self)
     * @param viewController The view controller which is going to be removed of self
     */
    func chh_uninstallChildViewController(_ viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
}
