//
//  AlertPresentingOperation.swift
//  Driver
//
//  Created by Татьяна Хохлова on 22/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import UIKit

class AlertPresentingOperation: AsyncOperation {

    private let alertViewController: UIAlertController
    private let alertHash: Int

    /**
     Создание операции для модального отображения view-controller-а
     - Parameter alertViewController: отображаемый view-controller
     - Parameter alertHash: уникальный идентификатор
     - Returns: инстанс операции
     */
    required init(alertViewController: UIAlertController,
                  alertHash: Int) {
        self.alertViewController = alertViewController
        self.alertHash = alertHash
        super.init()
        //  Чтобы не показывать алерт поверх алерта, операция завершится, когда алерт скроется
        NotificationCenter.default.addObserver(forName: .AlertDoneNotification,
                                               object: nil,
                                               queue: .main) { [weak self] notifiation in
                                                guard let self = self else { return }
                                                if let object = notifiation.object as? Int,
                                                    object == self.alertHash {
                                                    self.completeOperation()
                                                }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func main() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                let window = UIApplication.shared.keyWindow ,
                let viewControllerForPresentation = window.rootViewControllerForPresentation()  else { return }
            viewControllerForPresentation.present(self.alertViewController,
                                                  animated: true)
        }
    }

    override func cancel() {
        super.cancel()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.alertViewController.dismiss(animated: false) { [weak self] in
                guard let self = self else { return }
                self.completeOperation()
            }
        }
    }

}
