//
//  Configuration.swift
//  chh-test-ios
//
//  Created by André Caçador on 19/6/18.
//  Copyright © 2018 André Caçador. All rights reserved.
//

import Foundation

class Configuration {
    
    static let sharedInstance = Configuration()
    
    lazy var configs: NSDictionary! = {
        let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: "App Configuration")!
        let path = Bundle.main.path(forResource: "Configuration", ofType: "plist")!
        
        return NSDictionary(contentsOfFile: path)!.object(forKey: currentConfiguration) as! NSDictionary
    }()
    
}

extension Configuration {
    func apiEndpoint() -> String {
        return configs.object(forKey: "APIEndpoint") as! String
    }
}
