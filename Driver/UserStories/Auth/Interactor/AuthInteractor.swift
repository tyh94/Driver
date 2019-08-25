//
//  AuthInteractor.swift
//  Driver
//
//  Created by Татьяна Хохлова on 22/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import UIKit

class AuthInteractor: AuthInteractorProtocol {

    let network: NetworkService
    let storage: Storage

    required init(network: NetworkService,
                  storage: Storage) {
        self.network = network
        self.storage = storage
    }

    func login(phone: String,
               password: String,
               completion: @escaping (Result<Bool, AuthInteractorError>) -> ()) {
        let path = "https://testdriver.iwayex.com/v2/driver/auth/auth"
        let parameters = ["login": phone,
                          "password": password,
                          "device_info": [
                            "os": UIDevice.current.systemName,
                            "app_version": UIDevice.current.systemVersion,
                            "hardware_id": UIDevice.current.identifierForVendor!.uuidString
            ]
            ] as [String : Any]
        let url = URL(string: path)!
        network.request(url: url,
                        method: .post,
                        parameters: parameters,
                        headers: nil,
                        responseKey: "result") { [weak self] (result) in
                            switch result {
                            case .success(let value):
                                if let value = value as? [String: String] {
                                    if let token = value["token"] {
                                        self?.storage.store(token as NSCoding, key: AuthToken.accessToken.rawValue)
                                    }
                                    if let refreshToken = value["refresh_token"] {
                                        self?.storage.store(refreshToken as NSCoding, key: AuthToken.refreshToken.rawValue)
                                    }
                                    completion(.success(true))
                                } else {
                                    completion(.failure(.error(message: nil)))
                                }
                            case .failure(.error(let message)):
                                completion(.failure(.error(message: message)))
                            }
        }
    }

    func restorePassword(phone: String,
                         completion: @escaping (Result<Bool, AuthInteractorError>) -> ()) {
        let path = "https://testdriver.iwayex.com/v2/driver/auth/password"
        let parameters = ["login": phone]
        let url = URL(string: path)!
        network.request(url: url,
                        method: .post,
                        parameters: parameters,
                        headers: nil,
                        responseKey: "result") { (result) in
                            switch result {
                            case .success:
                                completion(.success(true))
                            case .failure(.error(let message)):
                                completion(.failure(.error(message: message)))
                            }
        }
    }

}
