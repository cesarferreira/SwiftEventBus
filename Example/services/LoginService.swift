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
        
        SwiftEventBus.onBackgroundThread(self, name:"loginCall") { _ in
         
            println("Starting request...")
            
            var useless = 0
            
            for index in 1...5000 {
                useless++
            }
            
            SwiftEventBus.post("login", sender: Person(name: "cesar ferreira"))
            
            
        }
   
    }
}
