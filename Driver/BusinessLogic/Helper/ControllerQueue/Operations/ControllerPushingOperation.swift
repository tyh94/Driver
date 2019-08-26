//
//  ControllerPushingOperation.swift
//  Driver
//
//  Created by Татьяна Хохлова on 22/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import UIKit

/**
 Операция навигационного показа view-controller-а
 */
class ControllerPushingOperation: AsyncOperation {

    private var pushViewController: UIViewController

    /**
     Создание операции для модального отображения view-controller-а
     - Parameter presentedViewController: отображаемый view-controller
     - Returns: инстанс операции
     */
    required init(pushViewController: UIViewController) {
        self.pushViewController = pushViewController
    }

    override func main() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let navigationViewController = self.navigationViewController()
            navigationViewController?.pushViewController(self.pushViewController,
                                                         animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                guard let self = self else { return }
                self.completeOperation()
            }
        }
    }

    func navigationViewController() -> UINavigationController? {
        let window = UIApplication.shared.keyWindow
        let rootViewControllerForPresentation = window?.rootViewControllerForPresentation()
        if let rootViewControllerForPresentation = rootViewControllerForPresentation as? UINavigationController {
            return rootViewControllerForPresentation
        }
        for child in rootViewControllerForPresentation?.children ?? [] {
            if let child = child as? UINavigationController {
                return child
            }
        }
        return nil
    }


}
