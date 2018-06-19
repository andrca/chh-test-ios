//
//  CoinListViewController.swift
//  chh-test-ios
//
//  Created by André Caçador on 19/6/18.
//  Copyright © 2018 André Caçador. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift

class CoinListViewController: BaseCollectionViewController {
    
    // MARK: Public properties
    
    let viewModel: CoinListViewModel
    
    // MARK: Lifecycle
    
    init(viewModel: CoinListViewModel) {
        self.viewModel = viewModel
        super.init(viewModel: viewModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupCollectionView()
        setupBindings()
    }
    
    // MARK: Private methods
    
    private func setupNavigationBar() {
        self.title = "Coins"
    }
    
    private func setupCollectionView() {
        collectionView.chh_registerCell(CoinListCell.self)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupBindings() {
        self.viewModel.numberCoins.producer.startWithValues { [weak self] _ in
            guard let strongSelf = self else { return }
            
            strongSelf.collectionView.reloadData()
        }
    }
    
    override func refreshData() {
        super.refreshData()
        
        self.viewModel.refreshData()
    }
}

extension CoinListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberCoins.value
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let coinListCell = collectionView.dequeueReusableCell(withReuseIdentifier: CoinListCell.preferredReuseIdentifier(), for: indexPath as IndexPath) as? CoinListCell
        coinListCell!.viewModel = self.viewModel.cellViewModelForIndexPath(indexPath)
        
        return coinListCell!
    }
    
}

extension CoinListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // let coin = viewModel.coinAt(indexPath as IndexPath)
        // self.viewModel.navigateToCoinDetails(coin!)
    }
    
}

extension CoinListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            return aspectFitFlowSize(flowLayout.itemSize, collectionView: collectionView)
        }
        
        return CGSize.zero
    }
    
    func aspectFitFlowSize(_ flowSize: CGSize, collectionView: UICollectionView) -> CGSize {
        
        let aspectRatio = flowSize.width / flowSize.height
        let width = collectionView.bounds.size.width
        let height = width / aspectRatio
        
        return CGSize(width: width, height: height)
    }
    
}
