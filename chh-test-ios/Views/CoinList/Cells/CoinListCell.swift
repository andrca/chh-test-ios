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
    
    //MARK: Private properties
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var symbolLabel: UILabel!
    @IBOutlet private weak var currentPriceLabel: UILabel!
    @IBOutlet private weak var percentageChange: UILabel!
    
    var viewModel: CoinListCellViewModel? {
        didSet {
            setupBindings()
        }
    }
    
    private func setupBindings() {
        nameLabel.rac_text <~ self.viewModel!.name
        symbolLabel.rac_text <~ self.viewModel!.symbol
        currentPriceLabel.rac_text <~ self.viewModel!.currentPrice
        percentageChange.rac_text <~ self.viewModel!.percentageChange
    }
    
}
