//
//  AuthViewOutput.swift
//  Driver
//
//  Created by Татьяна Хохлова on 22/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import Foundation

protocol AuthViewOutput {

    func needRestorePassword(login: String?)

    func login(phone: String,
               password: String)
    
}
