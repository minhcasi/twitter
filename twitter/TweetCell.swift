//
//  TweetCell.swift
//  twitter
//
//  Created by minh on 11/28/15.
//  Copyright © 2015 minh. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var tweetNumberLabel: UILabel!
    @IBOutlet weak var likeNumberLabel: UILabel!
    
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var retweetIcon: UIImageView!
    @IBOutlet weak var retweetHeaderLabel: UILabel!
   
    
    @IBOutlet weak var profileTopConstraint: NSLayoutConstraint!
   
    var tweet: Tweet! {
        didSet {
            
            nameLabel.text = tweet.user?.name
            timeLabel.text = Tools.formatDate(tweet.createdAt!)
            contentLabel.text = tweet.text
        
            profileImage.setImageWithURL(NSURL(string: tweet.user!.profileImageURL!)!)
            tweetNumberLabel.text = tweet.retweetCount > 0 ? "\(tweet.retweetCount!)" : ""
            likeNumberLabel.text = tweet.favoriteCount > 0 ? "\(tweet.favoriteCount!)" : ""
            
            if tweet.favorited {
                likeNumberLabel.textColor = Tools.likeColor
                likeButton.setImage(UIImage(named: "star-select"), forState: .Normal)
            } else {
                likeButton.setImage(UIImage(named: "star"), forState: .Normal)
            }
                        
            if tweet.retweeted {
                tweetNumberLabel.textColor = Tools.tweetColor
                retweetButton.setImage(UIImage(named: "retweet-select"), forState: .Normal)
            } else {
                retweetButton.setImage(UIImage(named: "retweet"), forState: .Normal)
            }
            
            
            self.retweetIcon.hidden = false
            if tweet.retweet != nil {
                let name = tweet.user?.name!
                retweetHeaderLabel.text = "\(name!) retweeted"
                retweetIcon.image = UIImage(named: "retweet")
                
                tweet = tweet.retweet
            }
            else if tweet.replyToScreenName != nil {
                retweetHeaderLabel.text = "In reply to @\(tweet.replyToScreenName!)"
                retweetIcon.image = UIImage(named: "back")
            }
            else {
                hideRetweet()
            }
        }
    }
    
    func hideRetweet() {
        retweetHeaderLabel.hidden = true
        retweetIcon.hidden = true
        profileTopConstraint.constant = 12
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImage.layer.cornerRadius = 8
        profileImage.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func retweetAction(sender: UIButton) {
        Tools.retweet(tweet, button: retweetButton, countLabel: tweetNumberLabel, isLargeIcon: false)
    }
    
    @IBAction func likeAction(sender: UIButton) {
        Tools.like(tweet, button: likeButton, countLabel: likeNumberLabel, isLargeIcon: false)
    }
}
