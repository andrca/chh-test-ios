//
//  UIKit+RACSupport.swift
//  chh-test-ios
//
//  Created by André Caçador on 19/6/18.
//  Copyright © 2018 André Caçador. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift

extension UIImageView {
    
    public var rac_image: MutableProperty<UIImage> {
        return lazyAssociatedProperty(self, key: &xoAssociationKey) {
            
            let property = MutableProperty<UIImage>(self.image ?? UIImage())
            property.producer
                .startWithValues { newValue in
                    self.image = newValue
            }
            
            return property
        }
    }
    
}

extension UILabel {
    
    public var rac_text: MutableProperty<String> {
        return lazyAssociatedProperty(self, key: &xoAssociationKey) {
            
            let property = MutableProperty<String>(self.text ?? "")
            property.producer
                .startWithValues({ (newValue) in
                    self.text = newValue
                })
            
            return property
        }
    }
    
    public var rac_textColor: MutableProperty<UIColor> {
        return lazyAssociatedProperty(self, key: &xoAssociationKey) {
            
            let property = MutableProperty<UIColor>(self.textColor ?? UIColor.white)
            property.producer
                .startWithValues({ (newValue) in
                    self.textColor = newValue
                })
            
            return property
        }
    }
    
    public var rac_attributedText: MutableProperty<NSAttributedString> {
        return lazyAssociatedProperty(self, key: &xoAssociationKey) {
            let property = MutableProperty<NSAttributedString>(self.attributedText ?? NSAttributedString())
            property.producer
                .startWithValues({ (newValue) in
                    self.attributedText = newValue
                })
            
            return property
        }
    }
    
}

extension UITextField {
    public var rac_text: MutableProperty<String> {
        return lazyAssociatedProperty(self, key: &xoAssociationKey) {
            
            self.addTarget(self, action: #selector(UITextField.changed), for: .editingChanged)
            
            let property = MutableProperty<String>(self.text ?? "")
            property.producer
                .startWithValues {
                    newValue in
                    self.text = newValue
            }
            return property
        }
    }
    
    @objc func changed() {
        rac_text.value = self.text ?? ""
    }
}

extension UIView {
    
    public var rac_backgroundColor: MutableProperty<UIColor> {
        return lazyAssociatedProperty(self, key: &xoAssociationKey) {
            
            let property = MutableProperty<UIColor>(self.backgroundColor ?? UIColor())
            property.producer
                .startWithValues({ (newValue) in
                    self.backgroundColor = newValue
                })
            
            return property
        }
    }
    
}

//MARK: Private
// Based on Colin's solution
// @see: https://github.com/ColinEberhardt/ReactiveTwitterSearch/blob/master/ReactiveTwitterSearch/Util/UIKitExtensions.swift

private var xoAssociationKey: UInt8 = 0

// lazily creates a gettable associated property via the given factory
private func lazyAssociatedProperty<T: AnyObject>(_ host: AnyObject, key: UnsafeRawPointer, factory: () -> T) -> T {
    return objc_getAssociatedObject(host, key) as? T ?? {
        let associatedProperty = factory()
        objc_setAssociatedObject(host, key, associatedProperty, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        
        return associatedProperty
        }()
}

private func lazyMutableProperty<T>(_ host: AnyObject, key: UnsafeRawPointer, setter: @escaping (T) -> (), getter: @escaping () -> T) -> MutableProperty<T> {
    return lazyAssociatedProperty(host, key: key) {
        let property = MutableProperty<T>(getter())
        property.producer
            .startWithValues{
                newValue in
                setter(newValue)
        }
        
        return property
    }
}
