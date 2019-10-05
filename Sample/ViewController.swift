//
//  ViewController.swift
//  Sample
//
//  Created by Cesar Ferreira on 17/09/2016.
//  Copyright © 2016 Cesar Ferreira. All rights reserved.
//

import UIKit
import SwiftEventBus

class ViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        SwiftEventBus.onMainThread(self, name: "login") { result in
            
            let p : Person = result?.object as! Person
            
            self.welcomeLabel.text = "Welcome \(p.name)"
            
        }
        
        SwiftEventBus.onMainThread(self, name: "loginFail") { _ in
            // handle herror on the UI thread
            print ("ERROR! Login failed");
        }
        
    }
    
    
    @IBAction func doClick(_ sender: AnyObject) {
        self.welcomeLabel.text = "Loading..."
        
        SwiftEventBus.post("loginCall")
    }
}

