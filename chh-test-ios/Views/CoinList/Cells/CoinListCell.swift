//
//  CoinListCell.swift
//  chh-test-ios
//
//  Created by André Caçador on 19/6/18.
//  Copyright © 2018 André Caçador. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift

class CoinListCell: BaseCollectionViewCell {
    
    //MARK: Public properties
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var percentageChange: UILabel!
    
    var viewModel: CoinListCellViewModel? {
        didSet {
            setupBindings()
        }
    }
    
    private func setupBindings() {
        nameLabel.rac_text <~ viewModel!.name
        currentPriceLabel.rac_text <~ viewModel!.currentPrice
        percentageChange.rac_text <~ viewModel!.percentageChange
    }
    
}
