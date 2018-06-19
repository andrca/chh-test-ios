//
//  DefaultNavigationBar.swift
//  chh-test-ios
//
//  Created by André Caçador on 19/6/18.
//  Copyright © 2018 André Caçador. All rights reserved.
//

import Foundation
import UIKit

class DefaultNavigationBar: UINavigationBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupNavigationBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupNavigationBar()
    }
    
    //MARK: Private Methods
    
    private func setupNavigationBar() {
        self.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.backgroundColor = UIColor.clear
        self.shadowImage = UIImage()
        self.barTintColor = UIColor.white
        self.tintColor = UIColor.chh_primaryColor()
        self.isTranslucent = false
        
        self.titleTextAttributes = [
            kCTForegroundColorAttributeName: UIColor.chh_primaryColor()
            ] as [NSAttributedStringKey : Any]
    }
    
}
