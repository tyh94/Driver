//
//  HelperAssembly.swift
//  Driver
//
//  Created by Татьяна Хохлова on 22/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import Swinject

class HelperAssembly: Assembly {

    func assemble(container: Container) {

        container.register(AuthStatusHelper.self) { _ in
            AuthStatusHelperImpl(
                storage: DependencyManager.getResolver().resolve(Storage.self, name: "keychain")!
            )
        }

        container.register(ControllerQueue.self) { (resolver) in
            ControllerQueueImpl()
            }.inObjectScope(.container)
    }

}
