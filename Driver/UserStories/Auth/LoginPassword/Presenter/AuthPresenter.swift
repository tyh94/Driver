//
//  AuthPresenter.swift
//  Driver
//
//  Created by Татьяна Хохлова on 22/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import UIKit

final class AuthPresenter {

    weak var viewInput: AuthViewInput?
    let router: AuthRouterInput
    let interactor: AuthInteractorProtocol

    required init(viewInput: AuthViewInput,
                  router: AuthRouterInput,
                  interactor: AuthInteractorProtocol) {
        self.viewInput = viewInput
        self.router = router
        self.interactor = interactor
    }

}

// MARK: - AuthViewOutput

extension AuthPresenter: AuthViewOutput {

    func needRestorePassword(login: String?) {
        router.showRestorePassword(login: login)
    }

    func login(phone: String,
               password: String) {
        if let phone = phone.convertPhoneNumber() {
            interactor.login(phone: phone,
                             password: password) { (result) in
                                DispatchQueue.main.async { [weak self] in
                                    self?.viewInput?.stopLoading()
                                    switch result {
                                    case .success:
                                        self?.router.showMain()
                                    case .failure(.error(let message)):
                                        self?.router.showErrorAlert(message: message)
                                    }
                                }
            }
        } else {
            router.showErrorAlert(message: "Некорректный номер телефона")
        }
    }
    
}

extension String {

    /**
     Получить телефон вида 8хххххххххх
     - Returns: строка - номер телефона в формате для отправки в API,
     nil - если:
     1) Номер начинается не с +7, 7 и 8.
     2) В номере не 11 символов, не включая "+"
     */
    func convertPhoneNumber() -> String? {
        var phoneNumber = components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        if phoneNumber.count == 11 {
            if phoneNumber.first != "8" {
                if phoneNumber.first == "7" {
                    phoneNumber.removeFirst()
                    phoneNumber = "8" + phoneNumber
                } else {
                    return nil
                }
            }
            return phoneNumber
        }
        return nil
    }
}
