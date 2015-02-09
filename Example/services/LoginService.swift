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
            
            // todo - fetch data from webservice
            
            // todo - parse json to object

            // in case of success
             SwiftEventBus.post("login", sender: Person(name: "cesar ferreira"))
            
        }

        
   
    }
}