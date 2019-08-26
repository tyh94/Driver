//
//  AsyncOperation.swift
//  Driver
//
//  Created by Татьяна Хохлова on 22/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import UIKit

class AsyncOperation: Operation {

    private var finish = false
    private var execute = false
    private let queue = DispatchQueue(label: "AsyncOperation")

    override var isAsynchronous: Bool { return true }
    override var isFinished: Bool { return finish }
    override var isExecuting: Bool { return execute }

    override func start() {
        if (isCancelled) {
            willChangeValue(forKey: "isFinished")
            finish = true
            didChangeValue(forKey: "isFinished")
            return
        }

        willChangeValue(forKey: "isExecuting")
        queue.async {
            self.main()
        }
        execute = true
        didChangeValue(forKey: "isExecuting")
    }

    func completeOperation() {
        willChangeValue(forKey: "isFinished")
        willChangeValue(forKey: "isExecuting")

        finish = true
        execute = false

        didChangeValue(forKey: "isFinished")
        didChangeValue(forKey: "isExecuting")
    }

}
