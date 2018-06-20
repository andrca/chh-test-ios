//
//  CoinDetailViewController.swift
//  chh-test-ios
//
//  Created by André Caçador on 19/6/18.
//  Copyright © 2018 André Caçador. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift
import SwiftChart
import SnapKit

class CoinDetailViewController: UIViewController, ChartDelegate {
    
    // MARK: Public properties
    
    let viewModel: CoinDetailViewModel
    
    // MARK: Private properties
    
    @IBOutlet private weak var coinPriceLabel: UILabel!
    @IBOutlet private weak var coinMarketCapLabel: UILabel!
    @IBOutlet private weak var coinVariationLabel: UILabel!
    @IBOutlet private weak var chartView: UIView!
    
    private let chart = Chart(frame: .zero)
    
    // MARK: Lifecycle
    
    init(viewModel: CoinDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyles()
        setupChart()
        setupNavigationBar()
        setupBindings()
    }
    
    // MARK: Private methods
    
    private func setupStyles() {}
    
    private func setupChart() {
        chart.delegate = self
        chart.yLabelsFormatter = { "$" + String(Int($1)) }
        chartView.addSubview(chart)
        chart.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        self.title = "Coin detail"
    }
    
    private func setupBindings() {
        self.coinPriceLabel.rac_text <~ self.viewModel.coinPriceUsd
        self.coinMarketCapLabel.rac_text <~ self.viewModel.coinMarketCapUsd
        self.coinVariationLabel.rac_text <~ self.viewModel.coinVariation
        
        self.viewModel.coinName.producer.startWithValues { [weak self] name in
            guard let strongSelf = self else { return }
            strongSelf.title = name
        }
        
        self.viewModel.orderedHistoricalList.producer.startWithValues { [weak self] h in
            guard let strongSelf = self else { return }
            let chartData = h.compactMap{ (Double($0.snapshotAt.timeIntervalSinceNow), $0.priceUsd) }
            let series = ChartSeries(data: chartData)
            series.area = true
            strongSelf.chart.add(series)
        }
    }

}

extension CoinDetailViewController {
    
    // Chart delegate
    func didTouchChart(_ chart: Chart, indexes: Array<Int?>, x: Double, left: CGFloat) {}
    
    func didFinishTouchingChart(_ chart: Chart) {}
    
    func didEndTouchingChart(_ chart: Chart) {}
    
}
