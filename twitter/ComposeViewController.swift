//
//  ComposeViewController.swift
//  twitter
//
//  Created by minh on 11/29/15.
//  Copyright © 2015 minh. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    @IBOutlet weak var contenText: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func cancelAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tweetAction(sender: AnyObject) {
        
        if contenText.text != nil {
            TwitterClient.instance.updateTweet(contenText.text!, completion: { (tweet, error) -> () in
                print("new tweet was created \(tweet)")
            })
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    @IBOutlet weak var cancelAction: UIBarButtonItem!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
