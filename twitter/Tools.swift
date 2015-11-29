//
//  DateFormat.swift
//  twitter
//
//  Created by minh on 11/29/15.
//  Copyright © 2015 minh. All rights reserved.
//

import UIKit

class Tools {
    static let defaultColor = UIColor(red: 96/255, green: 125/255, blue: 139/255, alpha: 1.0)
    static let tweetColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0)
    static let likeColor = UIColor(red: 233/255, green: 30/255, blue: 99/255, alpha: 1.0)
    
    static func formatDate(date: NSDate) -> String {
        let min = 60
        let hour = min * 60
        let day = hour * 24
        let week = day * 7
        
        let duration = Int(NSDate().timeIntervalSinceDate(date))
        
        if duration < min {
            return "\(duration)s"
        }
        
        if duration >= min && duration < hour {
            let minDur = duration / min
            return "\(minDur)m"
        }
        
        if duration >= hour && duration < day {
            let hourDur = duration / hour
            return "\(hourDur)h"
        }
        
        if duration >= day && duration < week {
            let dayDur = duration / day
            return "\(dayDur)d"
        }
        
        // more than one week
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "M/d/yy"
        return dateFormatter.stringFromDate(date)
    }
    
    
    static func formatFullDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = .ShortStyle
        
        return dateFormatter.stringFromDate(date)
    }
    
    static func retweet(tweet: Tweet, button: UIButton!, countLabel: UILabel!, isLargeIcon: Bool) {
        // had retweet already
        if tweet.retweeted  {
            var imageName = "retweet"
            if isLargeIcon {
                imageName = "retweet-32"
            }
        
            TwitterClient.instance.getRetweetedId(tweet.id!, completion: { (retweetedId, error) -> () in
                
                TwitterClient.instance.unRetweet(retweetedId!, completion: { (response, error) -> () in
                    if response != nil {
                        tweet.retweeted = false
                        
                        let retweetCount = tweet.retweetCount! - 1
                        tweet.retweetCount = retweetCount
                        
                        if retweetCount != 0 {
                            countLabel.text = "\(retweetCount)"
                        } else {
                            countLabel.text = ""
                        }
                        countLabel.textColor = Tools.defaultColor
                        
                        button.setImage(UIImage(named: imageName), forState: .Normal)
                    }
                })
            })
        }
        else {
            var imageName = "retweet-select"
            if isLargeIcon {
                imageName = "retweet-32-select"
            }
            
            TwitterClient.instance.retweet(tweet.id!, completion: { (response, error) -> () in
                if response != nil {
                    tweet.retweeted = true
                    
                    let retweetCount = tweet.retweetCount! + 1
                    tweet.retweetCount = retweetCount
                    
                    countLabel.text = "\(retweetCount)"
                    countLabel.textColor = Tools.tweetColor
                    
                    button.setImage(UIImage(named: imageName), forState: .Normal)
                }
            })
        }
    }
    
    static func like(tweet: Tweet, button: UIButton!, countLabel: UILabel!, isLargeIcon: Bool) {
        
        
        if tweet.favorited {
            var imageName = "star"
            if isLargeIcon {
                imageName = "star-32"
            }
            
            TwitterClient.instance.unLikeTweet(tweet.id!, completion: { (response, error) -> () in
                if response != nil {
                    tweet.favorited = false
                    
                    let favoriteCount = tweet.favoriteCount! - 1
                    tweet.favoriteCount = favoriteCount
                    
                    
                    if favoriteCount != 0 {
                        countLabel.text = "\(favoriteCount)"
                    } else {
                        countLabel.text = ""
                    }
                    countLabel.textColor = Tools.defaultColor
                    
                    button.setImage(UIImage(named: imageName), forState: .Normal)
                }
            })
        }
        else {
            var imageName = "star-select"
            if isLargeIcon {
                imageName = "star-32-select"
            }
            
            TwitterClient.instance.likeTweet(tweet.id!, completion: { (response, error) -> () in
                if response != nil {
                    tweet.favorited = true
                    let favoriteCount = tweet.favoriteCount! + 1
                    
                    tweet.favoriteCount = favoriteCount
                    countLabel.text = "\(favoriteCount)"
                    countLabel.textColor = Tools.likeColor
                    
                    button.setImage(UIImage(named: imageName), forState: .Normal)
                }
            })
        }
    }
}
