//
//  UIWindow+Utils.swift
//  Driver
//
//  Created by Татьяна Хохлова on 22/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import UIKit

public extension UIWindow {

    func rootViewControllerForPresentation() -> UIViewController? {
        var rootViewController = self.rootViewController
        while rootViewController?.presentedViewController != nil {
            rootViewController = rootViewController?.presentedViewController
        }
        return rootViewController
    }

}
