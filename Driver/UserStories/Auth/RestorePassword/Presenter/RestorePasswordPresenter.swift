//
//  RestorePasswordPresenter.swift
//  Driver
//
//  Created by Татьяна Хохлова on 22/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import UIKit

class RestorePasswordPresenter {

    weak var viewInput: RestorePasswordViewInput?
    let router: AuthRouterInput
    let interactor: AuthInteractorProtocol

    var startPhone: String?

    required init(viewInput: RestorePasswordViewInput,
                  router: AuthRouterInput,
                  interactor: AuthInteractorProtocol) {
        self.viewInput = viewInput
        self.router = router
        self.interactor = interactor
    }

    func configure(phone: String?) {
        startPhone = phone
    }

}

// MARK: - ResorePasswordViewOutput

extension RestorePasswordPresenter: RestorePasswordViewOutput {

    func restore(phone: String) {
        interactor.restorePassword(phone: phone) { (result) in
            DispatchQueue.main.async {  [weak self] in
                switch result {
                case .success:
                    self?.router.showMain()
                case .failure(.error(message: let message)):
                    self?.router.showErrorAlert(message: message)
                }
            }
        }
    }

    func moduleWasLoaded() {
        if let phone = startPhone {
            viewInput?.update(phone: phone)
        }
    }

}
