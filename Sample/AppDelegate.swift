//
//  AppDelegate.swift
//  Sample
//
//  Created by Cesar Ferreira on 17/09/2016.
//  Copyright © 2016 Cesar Ferreira. All rights reserved.
//

import UIKit
import SwiftEventBus

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Override point for customization after application launch.
        self.subscribeToServices()
        #if DEBUG
        self.runSmokeTestIfNeeded()
        #endif
        
        return true
    }
    
    func subscribeToServices() {
        let _ = LoginService.init()
        // todo - rest of the services
    }

    #if DEBUG
    private func runSmokeTestIfNeeded() {
        guard ProcessInfo.processInfo.arguments.contains("-SmokeTest") else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            SwiftEventBus.post("loginCall")
        }
    }
    #endif
    
    
}

