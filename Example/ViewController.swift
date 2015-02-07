//
//  ViewController.swift
//  Example
//
//  Created by César Ferreira on 07/02/15.
//  Copyright (c) 2015 cesarferreira. All rights reserved.
//

import UIKit
import SwiftEventBus

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        SwiftEventBus.onMainThread(self, name: "someEvent") { _ in
            println("I'm triggering due to a eventbus post!")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func performClick(sender: AnyObject) {
        
        SwiftEventBus.post("someEvent")
    }
}

