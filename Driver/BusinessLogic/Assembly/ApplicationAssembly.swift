//
//  ApplicationAssembly.swift
//  Driver
//
//  Created by Татьяна Хохлова on 22/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import Swinject

class ApplicationAssembly: Assembly {

    func assemble(container: Container) {

        container.register(ApplicationConfigurator.self) { (resolver) in
            ApplicationConfigurator(
                appearanceConfigurator: resolver.resolve(AppearanceConfigurator.self)!,
                appCoordinator: resolver.resolve(AppCoordinator.self)!
            )
        }

        container.register(AppearanceConfigurator.self) { (resolver) in
            AppearanceConfigatorDark()
        }

        container.register(AppCoordinator.self) { (resolver) in
            AppCoordinator(
                window: resolver.resolve(UIWindow.self)!,
                authStatus: DependencyManager.getResolver().resolve(AuthStatusHelper.self)!
            )
        }

        container.register(UIWindow.self) { (resolver) in
            UIWindow()
        }.inObjectScope(.container)
    }

}
