//
//  AuthStatusHelperImpl.swift
//  Driver
//
//  Created by Татьяна Хохлова on 22/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import Foundation

enum AuthToken: String {
    case accessToken
    case refreshToken
}

final class AuthStatusHelperImpl: AuthStatusHelper {

    let storage: Storage

    required init(storage: Storage) {
        self.storage = storage
    }

    func isAuthorize() -> Bool {
        return storage.object(key: AuthToken.accessToken.rawValue) != nil
    }

}
