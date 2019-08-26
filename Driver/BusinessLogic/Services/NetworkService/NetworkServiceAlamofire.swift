//
//  NetworkServiceAlamofire.swift
//  Driver
//
//  Created by Татьяна Хохлова on 22/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import Alamofire

final class NetworkServiceAlamofire {

    private let manager: SessionManager
    private let queue = DispatchQueue(label: "iway.com.auth.network.queue",
                                      qos: .userInitiated,
                                      attributes: .concurrent)

    required init(storage: Storage) {
        let timeout = 20.0
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeout
        configuration.timeoutIntervalForResource = timeout
        manager = Alamofire.SessionManager(configuration: configuration)
        let oauthHandler = OAuth2Handler(storage: storage)
        manager.retrier = oauthHandler
        manager.adapter = oauthHandler
        manager.session.configuration.timeoutIntervalForRequest = timeout
    }

    func convert(method: NetworkServiceMethod) -> HTTPMethod {
        switch method {
        case .get:
            return .get
        case .post:
            return .post
        }
    }

    func convert(encoding: NetworkServiceEncodding) -> ParameterEncoding {
        switch encoding {
        case .JSONEncodingDefault:
            return JSONEncoding.default
        case .ArrayEncoding:
            return ArrayEncoding()
        }
    }
    
}


extension NetworkServiceAlamofire: NetworkService {

    func request(url: URL,
                 method: NetworkServiceMethod,
                 parameters: [String: Any]?,
                 headers: [String: String]?,
                 responseKey: String?,
                 encodding: NetworkServiceEncodding,
                 completion: @escaping (Swift.Result<Any, NetworkServiceError>) -> ()) {
        manager.request(url,
                        method: convert(method: method),
                        parameters: parameters,
                        encoding: convert(encoding: encodding),
                        headers: headers)
            .validate()
            .responseJSON(queue: queue) { responseJSON in
                switch responseJSON.result {
                case .success(let value):
                    guard let responseKey = responseKey else {
                        completion(.success(value))
                        return
                    }
                    if let value = value as? [String: AnyHashable] {
                        if let json = value[responseKey],
                            !(json is NSNull) {
                            completion(.success(json))
                        } else if let error = value["error"] as? [String: AnyHashable] {
                            completion(.failure(.error(message: error["message"] as? String)))
                        } else {
                            completion(.failure(.error(message: nil)))
                        }
                    } else {
                        completion(.failure(.error(message: nil)))
                    }
                case .failure(let error):
                    completion(.failure(.error(message: error.localizedDescription)))
                }
        }
    }

}

private let arrayParametersKey = "arrayParametersKey"

extension Array {
    func asParameters() -> Parameters {
        return [arrayParametersKey: self]
    }
}


public struct ArrayEncoding: ParameterEncoding {

    public let options: JSONSerialization.WritingOptions


    public init(options: JSONSerialization.WritingOptions = []) {
        self.options = options
    }

    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()

        guard let parameters = parameters,
            let array = parameters[arrayParametersKey] else {
                return urlRequest
        }

        do {
            let data = try JSONSerialization.data(withJSONObject: array, options: options)

            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }

            urlRequest.httpBody = data

        } catch {
            throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
        }

        return urlRequest
    }

}
