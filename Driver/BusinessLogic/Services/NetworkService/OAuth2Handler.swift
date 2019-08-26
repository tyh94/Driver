//
//  OAuth2Handler.swift
//  Driver
//
//  Created by Татьяна Хохлова on 25/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import Foundation

import Alamofire

class OAuth2Handler: RequestAdapter, RequestRetrier {

    private typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?, _ refreshToken: String?) -> Void

    private let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        return SessionManager(configuration: configuration)
    }()

    private let storage: Storage

    private let lock = NSLock()

    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []

    // MARK: - Initializer

    required init(storage: Storage) {
        self.storage = storage
    }

    // MARK: - RequestAdapter

    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        if let accessToken = storage.object(key: AuthToken.accessToken.rawValue) as? String {
            var urlRequest = urlRequest
            urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
            return urlRequest
        }
        return urlRequest
    }

    // MARK: - RequestRetrier

    func should(_ manager: SessionManager,
                retry request: Request,
                with error: Error,
                completion: @escaping RequestRetryCompletion) {
        lock.lock()
        defer { lock.unlock() }

        if let response = request.task?.response as? HTTPURLResponse,
            response.statusCode == 401 {
            requestsToRetry.append(completion)

            if !isRefreshing {
                refreshTokens { [weak self] succeeded, accessToken, refreshToken in
                    guard let self = self else { return }
                    self.lock.lock()
                    defer { self.lock.unlock() }
                    if let accessToken = accessToken,
                        let refreshToken = refreshToken {
                        self.storage.store(accessToken as NSCoding, key: AuthToken.accessToken.rawValue)
                        self.storage.store(refreshToken as NSCoding, key: AuthToken.refreshToken.rawValue)
                    }

                    self.requestsToRetry.forEach { $0(succeeded, 0.0) }
                    self.requestsToRetry.removeAll()
                }
            }
        } else {
            completion(false, 0.0)
        }
    }

    // MARK: - Private - Refresh Tokens

    private func refreshTokens(completion: @escaping RefreshCompletion) {
        guard !isRefreshing else { return }

        isRefreshing = true

        if let refreshToken = storage.object(key: AuthToken.refreshToken.rawValue) as? String {
            let headers = ["Authorization": "Bearer \(refreshToken)"] as [String: String]
            let path = "https://testdriver.iwayex.com/v2/driver/auth/refresh"
            sessionManager.request(path,
                                   method: .post,
                                   headers: headers).responseJSON { [weak self] response in
                                    guard let self = self else {
                                        completion(false, nil, nil)
                                        return
                                    }
                                    if let json = response.result.value as? [String: Any],
                                        let result = json["result"] as? [String: Any],
                                        let token = result["token"] as? String,
                                        let refreshToken = result["refresh_token"] as? String {
                                        completion(true, token, refreshToken)
                                    } else {
                                        completion(false, nil, nil)
                                    }
                                    self.isRefreshing = false
            }
        } else {
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) { [weak self] in
                completion(false, nil, nil)
                self?.isRefreshing = false
            }
        }
    }

}

