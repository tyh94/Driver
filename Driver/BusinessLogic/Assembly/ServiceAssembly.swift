//
//  ServiceAssembly.swift
//  Driver
//
//  Created by Татьяна Хохлова on 22/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import Swinject

class ServiceAssembly: Assembly {

    func assemble(container: Container) {

        container.register(NetworkService.self) { (resolver) in
            NetworkServiceAlamofire(
                storage: DependencyManager.getResolver().resolve(Storage.self, name: "keychain")!
            )
        }
    }

}
