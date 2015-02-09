//
//  AppDelegate.swift
//  Example
//
//  Created by César Ferreira on 07/02/15.
//  Copyright (c) 2015 cesarferreira. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        // Init all the services
        self.subscribeToServices();

        
        return true
    }
    
    
    func subscribeToServices() {
        LoginService.init();
        // todo - rest of the services
    }
    


   

}

