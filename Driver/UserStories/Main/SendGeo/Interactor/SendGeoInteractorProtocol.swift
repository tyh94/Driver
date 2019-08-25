//
//  SendGeoInteractorProtocol.swift
//  Driver
//
//  Created by Татьяна Хохлова on 25/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import Foundation

protocol SendGeoInteractorProtocol {

    func sendGeo(latitude: Double,
                 longitude: Double,
                 completion: @escaping (Result<Bool, AuthInteractorError>) -> ())

    func exit()

}
