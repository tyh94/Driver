//
//  SendGeoViewInput.swift
//  Driver
//
//  Created by Татьяна Хохлова on 25/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import Foundation

protocol SendGeoViewInput: AnyObject {

    func updateGeo(latitude: Double, longitude: Double)

    func stopLoad()
    
}
