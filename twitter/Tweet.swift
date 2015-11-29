//
//  Tweet.swift
//  twitter
//
//  Created by minh on 11/28/15.
//  Copyright © 2015 minh. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var id: NSNumber?
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var retweetCount: Int?
    var favoriteCount: Int?
    
    var retweeted = false
    var favorited = false
    var retweet: Tweet?
    var replyToScreenName: String?
    
    init(dictionary: NSDictionary)  {
        id = dictionary["id"] as? NSNumber!
        
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        
        createdAtString = dictionary["created_at"] as? String
        retweetCount = dictionary["retweet_count"] as? Int!
        favoriteCount = dictionary["favorite_count"] as? Int!
        
        retweeted = (dictionary["retweeted"] as? Bool!)!
        favorited = (dictionary["favorited"] as? Bool!)!
        
        replyToScreenName = dictionary["in_reply_to_screen_name"] as? String!

        if let retweetedStatus = dictionary["retweeted_status"] as? NSDictionary {
            retweet = Tweet(dictionary: retweetedStatus)
        }

        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
}
