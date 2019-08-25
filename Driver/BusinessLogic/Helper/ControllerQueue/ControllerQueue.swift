//
//  ControllerQueue.swift
//  Driver
//
//  Created by Татьяна Хохлова on 22/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import UIKit

/**
 Протокол очереди для отображения view-controller-ов
 */
protocol ControllerQueue {

    /**
     Проверить, есть ли уже в очереди контроллеры
     - Returns: true есть, false - нет
     */
    func hasOperations() -> Bool

    /**
     Добавить контроллер для модального отображения в очередь
     - Parameter modalViewController: отображаемый контроллер
     */
    func add(modalViewController: UIViewController,
             completion: (() -> ())?)

    /**
     Добавить алерт контроллер для модального отображения в очередь
     - Parameter alertController: отображаемый контроллер
     - Parameter alertHash: уникальный идентификатор,
     необходим для корректного распознования нотификаций
     */
    func add(alertController: UIAlertController,
             alertHash: Int)

    /**
     Добавить контроллер для навигационного отображения в очередь
     - Parameter pushViewController: отображаемый контроллер
     */
    func add(pushViewController: UIViewController)

    /**
     Отменить все операции
     */
    func cancelAll()

}

extension ControllerQueue {

    func add(modalViewController: UIViewController,
             completion: (() -> ())? = nil) {
        add(modalViewController: modalViewController,
            completion: completion)
    }

}
