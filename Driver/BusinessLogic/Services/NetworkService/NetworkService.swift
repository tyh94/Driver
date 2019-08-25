//
//  NetworkService.swift
//  Driver
//
//  Created by Татьяна Хохлова on 22/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import Foundation

enum NetworkServiceMethod: String {
    case get
    case post
}

protocol NetworkService {

    func request(url: URL,
                 method: NetworkServiceMethod,
                 parameters: [String: Any]?,
                 headers: [String: String]?,
                 responseKey: String?,
                 completion: @escaping (Result<Any, NetworkServiceError>) -> ())
    
}

enum NetworkServiceError: Error {
    case error(message: String?)
}
