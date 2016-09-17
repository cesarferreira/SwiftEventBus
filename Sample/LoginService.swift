//
//  GetDataService.swift
//  EventMyBus
//
//  Created by César Ferreira on 06/02/15.
//  Copyright (c) 2015 linkedcare. All rights reserved.
//

import Foundation
import SwiftEventBus

class LoginService {
    init() {
        
        SwiftEventBus.onMainThread(self, name:"loginCall") { _ in
         
            print("Starting request...")
            
            var useless = 0
            
            for _ in 1...50000 {
                useless += 1
            }
                        
            print("Request finished...")

            SwiftEventBus.post("login", sender: Person(name: "cesar ferreira"))
            
        }
   
    }
}
