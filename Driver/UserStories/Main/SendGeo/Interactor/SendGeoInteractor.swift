//
//  SendGeoInteractor.swift
//  Driver
//
//  Created by Татьяна Хохлова on 25/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import Foundation

final class SendGeoInteractor {
    
    let network: NetworkService
    let storage: Storage

    required init(network: NetworkService,
                  storage: Storage) {
        self.network = network
        self.storage = storage
    }
    
}

extension SendGeoInteractor: SendGeoInteractorProtocol {

    func sendGeo(latitude: Double,
                 longitude: Double,
                 completion: @escaping (Result<Bool, AuthInteractorError>) -> ()) {
        let path = "https://testdriver.iwayex.com/v2/locations/create"
        let token = "Bearer \(storage.object(key: AuthToken.accessToken.rawValue)!)"
        let headers = ["Authorization": token]
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let parameters = [[
            "point": [
                "lat": latitude,
                "lng": longitude
            ],
            "trip_id": 1870188,
            "speed" : 0,
            "sent": dateFormatter.string(from: Date())
            ]
            ]
        let url = URL(string: path)!
        network.request(url: url,
                        method: .post,
                        parameters: parameters.asParameters(),
                        headers: headers,
                        responseKey: "result",
                        encodding: .ArrayEncoding) { (result) in
                            switch result {
                            case .success:
                                completion(.success(true))
                            case .failure(.error(let message)):
                                completion(.failure(.error(message: message)))
                            }
        }
    }

    func exit() {
        storage.store(nil, key: AuthToken.accessToken.rawValue)
        storage.store(nil, key: AuthToken.refreshToken.rawValue)
    }
    
}
