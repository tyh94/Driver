//
//  ApplicationConfigurator.swift
//  Driver
//
//  Created by Татьяна Хохлова on 22/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import UIKit

class ApplicationConfigurator {

    let appearanceConfigurator: AppearanceConfigurator
    let appCoordinator: AppCoordinator


    required init(appearanceConfigurator: AppearanceConfigurator,
                  appCoordinator: AppCoordinator) {
        self.appearanceConfigurator = appearanceConfigurator
        self.appCoordinator = appCoordinator
    }

    func start() {
        appearanceConfigurator.configure()
        appCoordinator.start()
    }

}
