//
//  DataManager.swift
//  chh-test-ios
//
//  Created by André Caçador on 19/6/18.
//  Copyright © 2018 André Caçador. All rights reserved.
//

import Foundation
import KeychainSwift

enum KeychainKey: String {
    case authentication = "io.jet8.authentication.key"
}

class DataManager {
    
    let keychain = KeychainSwift()
    
    func setSecure(_ value: String, forKey: KeychainKey) {
        keychain.set(value, forKey: forKey.rawValue)
    }
    
    func getSecure(_ key: KeychainKey) -> String? {
        return keychain.get(key.rawValue)
    }
    
    func deleteSecure(_ key: KeychainKey) -> Bool {
        return keychain.delete(key.rawValue)
    }
    
    func deleteAllKeys() -> Bool {
        return keychain.clear()
    }
}
