//
//  TweetDetailViewController.swift
//  twitter
//
//  Created by minh on 11/29/15.
//  Copyright © 2015 minh. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var createAtLabel: UILabel!
    
    @IBOutlet weak var numberOfRetweet: UILabel!
    @IBOutlet weak var numberOfLike: UILabel!
    
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyText: UITextField!
    
    var tweet: Tweet!
    
    func initData() {
        nameLabel.text = tweet.user?.name
        createAtLabel.text = Tools.formatFullDate(tweet.createdAt!)
        
        contentLabel.text = tweet.text
        
        profileImage.setImageWithURL(NSURL(string: tweet.user!.profileImageURL!)!)
        
        numberOfRetweet.text = tweet.retweetCount > 0 ? "\(tweet.retweetCount!)" : ""
        numberOfLike.text = tweet.favoriteCount > 0 ? "\(tweet.favoriteCount!)" : ""
        
        if tweet.favorited {
            numberOfLike.textColor = Tools.likeColor
            starButton.setImage(UIImage(named: "star-32-select"), forState: .Normal)
        } else {
            starButton.setImage(UIImage(named: "star-32"), forState: .Normal)
        }
        
        if tweet.retweeted {
            numberOfRetweet.textColor = Tools.tweetColor
            retweetButton.setImage(UIImage(named: "retweet-32-select"), forState: .Normal)
        } else {
            retweetButton.setImage(UIImage(named: "retweet-32"), forState: .Normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        dismissViewControllerAnimated(true , completion: nil)
    }
    
    @IBAction func retweetAction(sender: UIButton) {
        Tools.retweet(tweet, button: sender, countLabel: numberOfRetweet, isLargeIcon: true)
    }
    
    @IBAction func likeAction(sender: UIButton) {
        Tools.like(tweet, button: sender, countLabel: numberOfRetweet, isLargeIcon: true)
    }
    
    @IBAction func replyAction(sender: UIButton) {
        
        if replyText.text != nil {
            TwitterClient.instance.replyTweet(replyText.text!, originalId: tweet!.id!, completion: { (newTweet, error) -> () in
                
                if newTweet != nil {
                    self.tweet = newTweet
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            })
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
