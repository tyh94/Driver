//
//  AuthAssembly.swift
//  Driver
//
//  Created by Татьяна Хохлова on 22/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import Swinject
import SwinjectStoryboard

final class AuthAssembly: Assembly {

    func assemble(container: Container) {
        container.storyboardInitCompleted(AuthViewController.self) { (resolver, controller) in
            controller.viewOutput = resolver.resolve(AuthViewOutput.self,
                                                     argument: controller as AuthViewController)
        }

        container.register(AuthViewOutput.self) { (resolver, controller: AuthViewController) in
            AuthPresenter(
                viewInput: controller,
                router: resolver.resolve(AuthRouterInput.self)!,
                interactor: resolver.resolve(AuthInteractorProtocol.self)!
            )
        }
        
        container.storyboardInitCompleted(RestorePasswordViewController.self) { (resolver, controller) in
            controller.viewOutput = resolver.resolve(RestorePasswordViewOutput.self,
                                                     argument: controller as RestorePasswordViewController)
        }

        container.register(RestorePasswordViewOutput.self) { (resolver, controller: RestorePasswordViewController) in
            RestorePasswordPresenter(
                viewInput: controller,
                router: resolver.resolve(AuthRouterInput.self)!,
                interactor: resolver.resolve(AuthInteractorProtocol.self)!
            )
        }

        container.register(AuthRouterInput.self) { (resolver) in
            AuthRouter(
                controllerQueue: DependencyManager.getResolver().resolve(ControllerQueue.self)!,
                appCoordinator: DependencyManager.getResolver().resolve(AppCoordinator.self)!
            )
        }

        container.register(AuthInteractorProtocol.self) { (resolver) in
            AuthInteractor(
                network: DependencyManager.getResolver().resolve(NetworkService.self)!,
                storage: DependencyManager.getResolver().resolve(Storage.self, name: "keychain")!)
        }
    }

}
