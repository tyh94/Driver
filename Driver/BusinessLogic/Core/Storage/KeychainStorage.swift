//
//  KeychainStorage.swift
//  Driver
//
//  Created by Татьяна Хохлова on 22/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class KeychainStorage: Storage {

    let storage = KeychainWrapper.standard
    
    func store(_ item: NSCoding?, key: String) {
        if let item = item {
            storage.set(item, forKey: key)
        } else {
            storage.removeObject(forKey: key)
        }
    }

    func object(key: String) -> NSCoding? {
        return storage.object(forKey: key)
    }


}
