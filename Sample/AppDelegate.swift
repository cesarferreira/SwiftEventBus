//
//  AppDelegate.swift
//  Sample
//
//  Created by Cesar Ferreira on 17/09/2016.
//  Copyright © 2016 Cesar Ferreira. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.subscribeToServices()
        
        return true
    }
    
    func subscribeToServices() {
        LoginService.init()
        // todo - rest of the services
    }


}

