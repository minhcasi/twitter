//
//  ViewController.swift
//  twitter
//
//  Created by minh on 11/28/15.
//  Copyright © 2015 minh. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogin(sender: AnyObject) {
        TwitterClient.instance.loginWithCompletion() {
            (user: User?, error: NSError?) in
            
            if user != nil {
                // perform segue
                self.performSegueWithIdentifier("loginSegue", sender: self)
                
            }
            else {
                // handle login error 
                
            }
        }
        
    }
    

}

