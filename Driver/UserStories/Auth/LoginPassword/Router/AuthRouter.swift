//
//  AuthRouter.swift
//  Driver
//
//  Created by Татьяна Хохлова on 22/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import UIKit

final class AuthRouter: AuthRouterInput {

    let controllerQueue: ControllerQueue
    let appCoordinator: AppCoordinator

    required init(controllerQueue: ControllerQueue,
                  appCoordinator: AppCoordinator) {
        self.controllerQueue = controllerQueue
        self.appCoordinator = appCoordinator
    }

    func showRestorePassword(login: String?) {
        // если в очереди уже есть показ, то не показываем, избегает множественное нажатие на кнопки
        guard !controllerQueue.hasOperations() else { return }
        let sb = UIStoryboard(name: "Auth", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: String(describing: RestorePasswordViewController.self)) as! RestorePasswordViewController
        let presenter = vc.viewOutput as! RestorePasswordPresenter
        presenter.configure(phone: login)
        controllerQueue.add(pushViewController: vc)
    }

    func showErrorAlert(message: String?) {
        let alert = UIAlertController(title: message ?? "Что-то пошло не так",
                                      message: nil,
                                      preferredStyle: .alert)
        let alertHash = alert.hash
        alert.addAction(UIAlertAction(title: "ОК",
                                      style: .cancel,
                                      handler: { (_) in
                                        NotificationCenter.default.post(name: .AlertDoneNotification,
                                                                        object: alertHash)
        }))
        controllerQueue.add(alertController: alert, alertHash: alertHash)
    }

    func showMain() {
        appCoordinator.start()
    }

}
