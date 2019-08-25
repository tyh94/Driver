//
//  SendGeoAssembly.swift
//  Driver
//
//  Created by Татьяна Хохлова on 25/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import Swinject
import SwinjectStoryboard

class SendGeoAssembly: Assembly {

    func assemble(container: Container) {
        container.storyboardInitCompleted(SendGeoViewController.self) { (resolver, controller) in
            controller.viewOutput = resolver.resolve(SendGeoViewOutput.self,
                                                     argument: controller as SendGeoViewController)
        }

        container.register(SendGeoViewOutput.self) { (resolver, controller: SendGeoViewController) in
            SendGeoPresenter(
                viewInput: controller,
                interactor: resolver.resolve(SendGeoInteractorProtocol.self)!,
                router: resolver.resolve(SendGeoRouterInput.self)!
            )
        }

        container.register(SendGeoInteractorProtocol.self) { (resolver) in
            SendGeoInteractor(
                network: DependencyManager.getResolver().resolve(NetworkService.self)!,
                storage: DependencyManager.getResolver().resolve(Storage.self, name: "keychain")!
            )
        }

        container.register(SendGeoRouterInput.self) { (resolver) in
            SendGeoRouter(
                controllerQueue: DependencyManager.getResolver().resolve(ControllerQueue.self)!,
                appCoordinator: DependencyManager.getResolver().resolve(AppCoordinator.self)!
            )
        }
        
    }

}
