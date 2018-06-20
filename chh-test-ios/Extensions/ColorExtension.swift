//
//  ColorExtension.swift
//  chh-test-ios
//
//  Created by André Caçador on 19/6/18.
//  Copyright © 2018 André Caçador. All rights reserved.
//

import Foundation
import UIKit

/**
 * UIColor Extension
 *
 * This extension of UIKit's UIColor class pretends to define specific colors
 * that will be needed several times through the project.
 *
 * NOTE: Swift extensions on ObjC classes still need to be prefixed
 * SEE: https://pspdfkit.com/blog/2016/surprises-with-swift-extensions/
 */
extension UIColor {
    
    static func chh_primaryColor() -> UIColor {
        return UIColor.black
    }
}
