//
//  AuthInteractorProtocol.swift
//  Driver
//
//  Created by Татьяна Хохлова on 22/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import Foundation

protocol AuthInteractorProtocol {

    func login(phone: String,
               password: String,
               completion: @escaping (Result<Bool, AuthInteractorError>) -> ())

    func restorePassword(phone: String,
                         completion: @escaping (Result<Bool, AuthInteractorError>) -> ())
    
}

enum AuthInteractorError: Error {
    case error(message: String?)
}
