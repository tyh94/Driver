//
//  SendGeoRouter.swift
//  Driver
//
//  Created by Татьяна Хохлова on 25/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import UIKit

class SendGeoRouter: SendGeoRouterInput {

    let controllerQueue: ControllerQueue
    let appCoordinator: AppCoordinator

    required init(controllerQueue: ControllerQueue,
                  appCoordinator: AppCoordinator) {
        self.controllerQueue = controllerQueue
        self.appCoordinator = appCoordinator
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: message,
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

    func openGeoAccessAlert() {
        showAlert(title: "Геопозиция",
                  message: "Для использования геопозиции включите её в настройках")
    }

    func showMain() {
        appCoordinator.start()
    }

    private func openSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL,
                                      options: [:],
                                      completionHandler: nil)
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let alertHash = alert.hashValue
        alert.addAction(UIAlertAction(
            title: "Настройки",
            style: .default,
            handler: { [weak self] (action) in
                self?.openSettings()
                NotificationCenter.default.post(name: .AlertDoneNotification, object: alertHash)
            }
        ))
        alert.addAction(UIAlertAction(
            title: "Отмена",
            style: .cancel,
            handler: { _ in
                NotificationCenter.default.post(name: .AlertDoneNotification, object: alertHash)
        }
        ))
        controllerQueue.add(alertController: alert,
                            alertHash: alertHash)
    }

}
