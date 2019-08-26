//
//  ControllerQueueImpl.swift
//  Driver
//
//  Created by Татьяна Хохлова on 22/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import UIKit

class ControllerQueueImpl: NSObject {

    let operationQueue: OperationQueue

    override init() {
        operationQueue = OperationQueue()
        operationQueue.name = "iway.controller.queue"
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.qualityOfService = .userInteractive
    }

}

// MARK: ControllerQueue

extension ControllerQueueImpl: ControllerQueue {

    func hasOperations() -> Bool {
        return operationQueue.operationCount > 0
    }

    func add(modalViewController: UIViewController,
             completion: (() -> ())?) {
        let operation = ControllerPresentingOperation(presentedViewController: modalViewController,
                                                      completion: completion)
        operationQueue.addOperation(operation)
    }

    func add(alertController: UIAlertController,
             alertHash: Int) {
        let operation = AlertPresentingOperation(alertViewController: alertController,
                                                 alertHash: alertHash)
        operationQueue.addOperation(operation)
    }

    func add(pushViewController: UIViewController) {
        let operation = ControllerPushingOperation(pushViewController: pushViewController)
        operationQueue.addOperation(operation)
    }

    func cancelAll() {
        operationQueue.cancelAllOperations()
    }

}
