//
//  TweetsViewController.swift
//  twitter
//
//  Created by minh on 11/28/15.
//  Copyright © 2015 minh. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tweets: [Tweet]?
    @IBOutlet weak var tableView: UITableView!
    var refreshControl : UIRefreshControl!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 230
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        initData()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "initData", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
    }

    func initData() {
        TwitterClient.instance.homeTimelineWithCompletion(nil, completion: { (tweets, error) -> () in
            print("refresh data \(tweets?.count)")
            
            self.tweets = tweets
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        })
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func logOutAction(sender: AnyObject) {
        User.currentUser?.logOut()
        
    }

    
    // return number of rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("total table row \(tweets?.count)")
        if (tweets != nil)  {
            return (tweets?.count)!
        }
        return 0;
    }
    
    // populate cell data
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
        cell.tweet = tweets![indexPath.row]
        return cell
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nv = segue.destinationViewController as! UINavigationController
        
        switch (nv.topViewController) {
        case is TweetDetailViewController:
            let detailVC = nv.topViewController as! TweetDetailViewController
            
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            detailVC.tweet = tweets![indexPath!.row]
            
            print("is detail view")
            break
        case is ComposeViewController:
            _ = nv.topViewController as! ComposeViewController
            
            
            print("is compose view")
            break
        default:
            break
        }
    }
}
