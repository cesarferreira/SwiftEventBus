//
//  GetDataService.swift
//  EventMyBus
//
//  Created by César Ferreira on 06/02/15.
//  Copyright (c) 2015 linkedcare. All rights reserved.
//

import Foundation
import SwiftEventBus
import Alamofire

class LoginService {
    init() {
        
        SwiftEventBus.onBackgroundThread(self, name:"loginCall") { _ in
         
            println("Starting request...")
            
            // fetch data from webservice
            Alamofire.request(.GET, "http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=funny+cat")
                .responseJSON { (_, _, JSON, _) in
                    // todo - parse json into an object

                    let variavel: AnyObject? = JSON

                    println(variavel)
                    
                    if (variavel != nil) {
                        // in case of success
                        SwiftEventBus.post("login", sender: Person(name: "cesar ferreira"))

                    } else {
                        // in case of failure

                        SwiftEventBus.post("loginFail")

                    }
                    
                  
                    
            }
            
            

            
        }

        
   
    }
}