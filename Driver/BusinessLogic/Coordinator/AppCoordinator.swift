//
//  AppCoordinator.swift
//  Driver
//
//  Created by Татьяна Хохлова on 22/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {

    let window: UIWindow
    let authStatus: AuthStatusHelper

    required init(window: UIWindow,
                  authStatus: AuthStatusHelper) {
        self.window = window
        self.authStatus = authStatus
    }

    func start() {
        var vc: UIViewController
        if authStatus.isAuthorize() {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            vc = sb.instantiateInitialViewController()!
        } else {
            let sb = UIStoryboard(name: "Auth", bundle: nil)
            vc = sb.instantiateInitialViewController()!
        }
        vc.modalTransitionStyle = .flipHorizontal
        UIView.transition(with: window,
                          duration: window.rootViewController == nil ? 0 : 0.5,
                          options: .transitionFlipFromLeft,
                          animations: {
                            self.window.rootViewController = vc
                            self.window.makeKeyAndVisible()
        }, completion: { completed in
        })
    }

}

