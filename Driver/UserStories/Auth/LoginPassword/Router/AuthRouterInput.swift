//
//  AuthRouterInput.swift
//  Driver
//
//  Created by Татьяна Хохлова on 22/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import UIKit

protocol AuthRouterInput {

    func showRestorePassword(login: String?)

    func showErrorAlert(message: String?)

    func showMain()

}
