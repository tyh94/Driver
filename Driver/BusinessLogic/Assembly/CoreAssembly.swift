//
//  CoreAssembly.swift
//  Driver
//
//  Created by Татьяна Хохлова on 22/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import Swinject

class CoreAssembly: Assembly {

    func assemble(container: Container) {

        container.register(Storage.self, name: "keychain") { _ in
            KeychainStorage()
        }

    }

}
