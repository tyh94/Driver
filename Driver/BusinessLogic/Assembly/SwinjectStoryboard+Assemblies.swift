//
//  SwinjectStoryboard+Assemblies.swift
//  Driver
//
//  Created by Татьяна Хохлова on 22/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import SwinjectStoryboard

extension SwinjectStoryboard {

    public static func setup() {
        AuthAssembly().assemble(container: defaultContainer)
        SendGeoAssembly().assemble(container: defaultContainer)
    }

}
