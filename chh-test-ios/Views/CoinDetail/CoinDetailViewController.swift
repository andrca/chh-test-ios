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
    private let addTradeAlertController = UIAlertController(title: "Add New Trade", message: "", preferredStyle: .alert)
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
        
        setupChart()
        setupAddTradeAlertController()
        setupNavigationBar()
        setupBindings()
    }
    
    // MARK: Private methods
    
    private func setupAddTradeAlertController() {
        addTradeAlertController.addAction(UIAlertAction(title: "Add", style: .default, handler: {
            alert -> Void in
            let amountField = self.addTradeAlertController.textFields![0] as UITextField
            let priceUsdField = self.addTradeAlertController.textFields![1] as UITextField
            let tradedAtField = self.addTradeAlertController.textFields![2] as UITextField
            let notesField = self.addTradeAlertController.textFields![3] as UITextField
            
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
                    self.present(self.addTradeAlertController, animated: true, completion: nil)
                }))
                self.present(errorAlert, animated: true, completion: nil)
            }
        }))
        
        addTradeAlertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel))
        
        addTradeAlertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Amount"
            textField.textAlignment = .center
            textField.keyboardType = .decimalPad
        })
        
        addTradeAlertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Price USD"
            textField.textAlignment = .center
            textField.keyboardType = .decimalPad
        })
        
        addTradeAlertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Traded At"
            textField.textAlignment = .center
            
            let datePickerView: UIDatePicker = UIDatePicker()
            datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
            textField.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        })
        
        addTradeAlertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Notes"
            textField.textAlignment = .center
        })
    }
    
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add",
            style: .plain,
            target: self,
            action: #selector(newTradeTapped))
    }
    
    @objc private func newTradeTapped() {
        self.addTradeAlertController.textFields!.forEach { $0.text = "" }
        self.present(addTradeAlertController, animated: true, completion: nil)
    }
    
    @objc private func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        let dateTextField = self.addTradeAlertController.textFields![2] as UITextField
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
    
    func didTouchChart(_ chart: Chart, indexes: Array<Int?>, x: Double, left: CGFloat) {}
    
    func didFinishTouchingChart(_ chart: Chart) {}
    
    func didEndTouchingChart(_ chart: Chart) {}
    
}
