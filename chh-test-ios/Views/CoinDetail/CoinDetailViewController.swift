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
    private let alertController = UIAlertController(title: "Add New Trade", message: "", preferredStyle: .alert)
    private var tradedAtDate = Date()
    
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(newTradeTapped))
    }
    
    @objc private func newTradeTapped() {
        alertController.addAction(UIAlertAction(title: "Add", style: .default, handler: {
            alert -> Void in
            let amountField = self.alertController.textFields![0] as UITextField
            let priceUsdField = self.alertController.textFields![1] as UITextField
            let tradedAtField = self.alertController.textFields![2] as UITextField
            let notesField = self.alertController.textFields![3] as UITextField
            
            if amountField.text != "", priceUsdField.text != "", tradedAtField.text != "" {
                guard let amount = Float(amountField.text!),
                    let priceUsd = Float(priceUsdField.text!)
                    else {
                        return
                }
                
                self.viewModel.didAddedNewTrade(
                    amount: amount,
                    priceUsd: priceUsd,
                    tradedAt: self.tradedAtDate,
                    notes: notesField.text)
            } else {
                let errorAlert = UIAlertController(title: "Error", message: "Empty values", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
                    alert -> Void in
                    self.present(self.alertController, animated: true, completion: nil)
                }))
                self.present(errorAlert, animated: true, completion: nil)
            }
        }))
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Amount"
            textField.textAlignment = .center
            textField.keyboardType = .decimalPad
        })
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Price USD"
            textField.textAlignment = .center
            textField.keyboardType = .decimalPad
        })
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Traded At"
            textField.textAlignment = .center
            
            let datePickerView: UIDatePicker = UIDatePicker()
            datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
            textField.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        })
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Notes"
            textField.textAlignment = .center
        })
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        let dateTextField = self.alertController.textFields![2] as UITextField
        tradedAtDate = sender.date
        dateTextField.text = dateFormatter.string(from: sender.date)
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
