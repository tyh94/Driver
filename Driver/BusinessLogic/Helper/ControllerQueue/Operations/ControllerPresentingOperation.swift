//
//  ControllerPresentingOperation.swift
//  Driver
//
//  Created by Татьяна Хохлова on 22/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import UIKit

/**
 Операция модального показа view-controller-а
 */
class ControllerPresentingOperation: AsyncOperation {

    private var presentedViewController: UIViewController
    private var completion: (() -> ())?

    /**
     Создание операции для модального отображения view-controller-а
     - Parameter presentedViewController: отображаемый view-controller
     - Returns: инстанс операции
     */
    required init(presentedViewController: UIViewController,
                  completion: (() -> ())?) {
        self.presentedViewController = presentedViewController
        self.completion = completion
    }

    override func main() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let window = UIApplication.shared.keyWindow
            var viewControllerForPresentation = window?.rootViewControllerForPresentation()
            
            if let navigationController = viewControllerForPresentation as? UINavigationController,
                let visibleViewController = navigationController.visibleViewController {
                viewControllerForPresentation = visibleViewController
            }
            viewControllerForPresentation?.present(self.presentedViewController,
                                                   animated: true) { [weak self] in
                                                    self?.completion?()
                                                    self?.completeOperation()
            }
        }
    }

    override func cancel() {
        super.cancel()
        presentedViewController.dismiss(animated: false) { [weak self] in
            guard let self = self else { return }
            self.completeOperation()
        }
    }

}
