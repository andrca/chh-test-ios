//
//  CollectionViewExtension.swift
//  chh-test-ios
//
//  Created by André Caçador on 19/6/18.
//  Copyright © 2018 André Caçador. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    
    func chh_registerCell(_ type: BaseCollectionViewCell.Type) {
        let nib = UINib(nibName: type.preferredReuseIdentifier(), bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: type.preferredReuseIdentifier())
    }
    
    func chh_registerHeaderView(_ type: BaseCollectionReusableView.Type) {
        let nib = UINib(nibName: type.preferredReuseIdentifier(), bundle: nil)
        self.register(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: type.preferredReuseIdentifier())
    }
    
    func chh_aspectFitFlowSize(_ flowSize: CGSize) -> CGSize {
        let aspectRatio = flowSize.width / flowSize.height
        let width = self.bounds.size.width
        let height = width / aspectRatio
        
        return CGSize(width: width, height: height)
    }
    
}
