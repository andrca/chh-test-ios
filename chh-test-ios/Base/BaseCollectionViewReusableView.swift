//
//  BaseCollectionViewReusableView.swift
//  chh-test-ios
//
//  Created by André Caçador on 19/6/18.
//  Copyright © 2018 André Caçador. All rights reserved.
//

import Foundation
import UIKit

class BaseCollectionReusableView: UICollectionReusableView {
    
    class func preferredReuseIdentifier() -> String {
        return String(describing: self)
    }
    
}
