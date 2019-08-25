//
//  Storage.swift
//  Driver
//
//  Created by Татьяна Хохлова on 22/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import Foundation


protocol Storage {

    func store(_ item: NSCoding?, key: String)

    func object(key: String) -> NSCoding?

}
