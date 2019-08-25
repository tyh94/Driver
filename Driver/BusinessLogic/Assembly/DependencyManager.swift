//
//  DependencyManager.swift
//  Driver
//
//  Created by Татьяна Хохлова on 22/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import Swinject

internal class DependencyManager {
    
    private static let sharedInstance = DependencyManager()

    private var assembler: Assembler
    private let container: Container

    class func getResolver() -> Resolver {
        return sharedInstance.assembler.resolver
    }

    class func getContainer() -> Container {
        return sharedInstance.container
    }

    private init() {
        container = Container()
        assembler = Assembler([
            ServiceAssembly(),
            HelperAssembly(),
            CoreAssembly(),
            ApplicationAssembly()
            ])
    }
}
