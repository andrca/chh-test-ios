//
//  BaseCollectionViewController.swift
//  chh-test-ios
//
//  Created by André Caçador on 19/6/18.
//  Copyright © 2018 André Caçador. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift

protocol ViewModelerProtocol {
    var refresher: UIRefresherProtocol { get set }
}

class BaseCollectionViewController: UIViewController, ViewModelerProtocol {
    @IBOutlet private(set) weak var collectionView: UICollectionView!
    
    var refresher: UIRefresherProtocol
    
    init(viewModel: UIRefresherProtocol) {
        self.refresher = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRefreshSignal()
    }
    
    func setupRefreshSignal() {
        refresher.refreshUISignal.signal
            .filter{ $0 == true }
            .observeValues { [unowned self] _ in
                self.collectionView.reloadData()
        }
    }
    
    /**
     If refreshControl is added, the subclass must override this function to launch the necessary actions when
     activated refreshControl
     */
    func refreshData() {}
}
