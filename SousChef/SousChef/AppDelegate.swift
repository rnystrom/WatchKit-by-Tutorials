//
//  AppDelegate.swift
//  SousChef
//
//  Created by Ryan Nystrom on 11/24/14.
//  Copyright (c) 2014 Ryan Nystrom. All rights reserved.
//

import UIKit
import SousChefKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    configureAppearance()

    application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound | UIUserNotificationType.Alert, categories: nil))

    return true
  }

  func configureAppearance() {
    let navBarAppearance = UINavigationBar.appearance()
    navBarAppearance.titleTextAttributes = [
      NSForegroundColorAttributeName: Theme.navTextColor,
      NSFontAttributeName: Theme.navFont!
    ]
    navBarAppearance.barTintColor = Theme.baseColor
    navBarAppearance.tintColor = Theme.navTextColor

    let tabBarAppearance = UITabBar.appearance()
    tabBarAppearance.tintColor = Theme.baseColor
  }

}

