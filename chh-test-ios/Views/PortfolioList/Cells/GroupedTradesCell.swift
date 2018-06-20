//
//  GroupedTradesCell.swift
//  chh-test-ios
//
//  Created by André Caçador on 20/6/18.
//  Copyright © 2018 André Caçador. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift

class GroupedTradesCell: BaseCollectionViewCell {
    
    //MARK: Private properties
    
    @IBOutlet private weak var coinNameLabel: UILabel!
    @IBOutlet private weak var amounLabel: UILabel!
    @IBOutlet private weak var priceUsdLabel: UILabel!
    
    var viewModel: GroupedTradesCellViewModel? {
        didSet {
            setupBindings()
        }
    }
    
    private func setupBindings() {
        coinNameLabel.rac_text <~ self.viewModel!.coinName
        amounLabel.rac_text <~ self.viewModel!.amount
        priceUsdLabel.rac_text <~ self.viewModel!.priceUsd
    }
    
}
