//
//  CoinListViewModel.swift
//  chh-test-ios
//
//  Created by André Caçador on 19/6/18.
//  Copyright © 2018 André Caçador. All rights reserved.
//

import Foundation
import ReactiveSwift
import BrightFutures

protocol UIRefresherProtocol {
    var refreshUISignal: MutableProperty<Bool> { get }
    
    func refreshData()
}


class CoinListViewModel: UIRefresherProtocol {
    
    //MARK: Public properties
    
    let refreshUISignal = MutableProperty<Bool>(false)
    var isLoading = MutableProperty<Bool>(false)
    let numberCryptos = MutableProperty<Int>(0)
    let router: CryptosListRouter
    
    init(router: CryptosListRouter) {
        self.router = router
        
        setupBindings()
        retrieveCryptos()
    }
    
    // MARK: Public methods
    
    func cellViewModelForIndexPath(_ indexPath: IndexPath) -> AppointmentCellViewModel? {
        let appointment = appointmentAt(indexPath)
        return AppointmentCellViewModel(appointment!)
    }
    
    func cellImageForIndexPath(_ indexPath: IndexPath) -> UIImage? {
        let appointment = appointmentAt(indexPath)
        return professionalImages.value[appointment!.professional.ID]
    }
    
    func appointmentAt(_ indexPath: IndexPath) -> Appointment? {
        guard let appointment = appointmentOrderedList.value[indexPath.row] as Appointment? else {
            logError(logText: "[\(type(of: self))] \(#function) Out range (\(indexPath.row)) of category with \(self.appointmentList.value.count) element/s")
            
            return nil
        }
        
        return appointment
    }
    
    func refreshData() {
        retrieveAppointments()
    }
}
