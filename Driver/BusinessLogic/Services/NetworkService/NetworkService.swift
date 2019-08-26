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

enum NetworkServiceEncodding: String {
    case JSONEncodingDefault
    case ArrayEncoding
}

protocol NetworkService {

    func request(url: URL,
                 method: NetworkServiceMethod,
                 parameters: [String: Any]?,
                 headers: [String: String]?,
                 responseKey: String?,
                 encodding: NetworkServiceEncodding,
                 completion: @escaping (Result<Any, NetworkServiceError>) -> ())
    
}

extension NetworkService {

    func request(url: URL,
                 method: NetworkServiceMethod,
                 parameters: [String: Any]?,
                 headers: [String: String]?,
                 responseKey: String?,
                 encodding: NetworkServiceEncodding = .JSONEncodingDefault,
                 completion: @escaping (Result<Any, NetworkServiceError>) -> ()) {
        self.request(url: url,
                     method: method,
                     parameters: parameters,
                     headers: headers,
                     responseKey: responseKey,
                     encodding: encodding,
                     completion: completion)
    }

}

enum NetworkServiceError: Error {
    case error(message: String?)
}
