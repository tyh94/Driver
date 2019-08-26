//
//  AppearanceConfigator.swift
//  Driver
//
//  Created by Татьяна Хохлова on 22/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import UIKit

final class AppearanceConfigatorDark: AppearanceConfigurator {

    func configure() {
        UINavigationBar.appearance().barTintColor = UIColor(named: "mainContentColor")
        UINavigationBar.appearance().tintColor = UIColor(named: "titleTextColor")
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UIActivityIndicatorView.appearance().tintColor = UIColor(named: "titleTextColor")
        UITextField.appearance().keyboardAppearance = .dark
    }

}


