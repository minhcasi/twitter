//
//  TwitterClient.swift
//  twitter
//
//  Created by minh on 11/28/15.
//  Copyright © 2015 minh. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "cUFy6ZW7hsWsInsemjdrkTc1x"
let twitterConsumerSecret = "AKnJEgyujfM6ua8miHFZnnpHNPhAL1987Szr9vs6TaCMQyfj99"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {

    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var instance : TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL,
                consumerKey: twitterConsumerKey,
                consumerSecret: twitterConsumerSecret)

        }
        
        return Static.instance
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // fetch requestion token & redirecto to authoriztion page
        TwitterClient.instance.requestSerializer.removeAccessToken()
        
        TwitterClient.instance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("get the request token")
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            
            UIApplication.sharedApplication().openURL(authURL!)
            
            }, failure: { (error: NSError!) -> Void in
                print ("Fail to get request token")
                
                self.loginCompletion?(user: nil, error: error)
        })
    }
    
    func homeTimelineWithCompletion(params: NSDictionary?, completion:(tweets: [Tweet]?, error: NSError?) -> ()) {
        
        
        print("Start request")
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation, response: AnyObject!) -> Void in
        
//            print("home timeline: \(response)")
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
        
            completion(tweets: tweets, error: nil)
            },
            failure: { (operation: AFHTTPRequestOperation?, error:NSError) -> Void in
                print("error getting tweets \(error)")
                completion(tweets: nil, error: error)
        })
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            
            print("got the access token")
            TwitterClient.instance.requestSerializer.saveAccessToken(accessToken)
            
            
            // init user object
            TwitterClient.instance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation, response: AnyObject!) -> Void in
                //                    print("home timeline: \(response)")
                let user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                
                print("user: \(user.name!)")
                
                self.loginCompletion?(user: user, error: nil)
                
                }, failure: { (operation: AFHTTPRequestOperation?, error:NSError) -> Void in
                    print("error getting current users \(error)")
                    self.loginCompletion?(user: nil, error: error)
            })
            
            
            }) { (error: NSError!) -> Void in
                print("Fail to receive access token")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func retweet(id: NSNumber, completion: (response: AnyObject?, error: NSError?) -> ()) {
        
        let request = "1.1/statuses/retweet/\(id).json"
        
        POST(request, parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
            completion(response: response, error: nil)
            
            }, failure: { (operation: AFHTTPRequestOperation?, error:NSError) -> Void in
                print("error retweet \(error)")
                completion(response: nil, error: error)
        })
    }
    
    
    func unRetweet(id: NSNumber, completion: (response: AnyObject?, error: NSError?) -> ()) {
        POST("1.1/statuses/destroy/\(id).json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
            completion(response: response, error: nil)
            
            }, failure: { (operation: AFHTTPRequestOperation?, error: NSError!) -> Void in
                print("error unretweeting \(error)")
                completion(response: nil, error: error)
        })
    }
    
    
    func getRetweetedId(id: NSNumber, completion: (retweetedId: NSNumber?, error: NSError?) -> ()) {
        let params = ["include_my_retweet" : true]
        
        GET("1.1/statuses/show/\(id).json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
            let tweet = response as! NSDictionary
            let curUserRetweet = tweet["current_user_retweet"] as! NSDictionary
            
            completion(retweetedId: curUserRetweet["id"]! as? NSNumber, error: nil)
            
            print("rewteet id \(curUserRetweet["id"])")
            
            }, failure: { (operation: AFHTTPRequestOperation?, error: NSError!) -> Void in
                print("error get retweet id \(error)")
                completion(retweetedId: nil, error: error)
        })
    }
    
    
    
    func likeTweet(id: NSNumber, completion: (response: AnyObject?, error: NSError?) -> ()) {
        let params = ["id" : id]
        POST("1.1/favorites/create.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            completion(response: response, error: nil)
            
            }, failure: { (operation: AFHTTPRequestOperation?, error: NSError!) -> Void in
                print("error like tweet \(error)")
                completion(response: nil, error: error)
        })
    }
    
    func unLikeTweet(id: NSNumber, completion: (response: AnyObject?, error: NSError?) -> ()) {
        let params = ["id" : id]
        
        POST("1.1/favorites/destroy.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            completion(response: response, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation?, error: NSError!) -> Void in
                print("error unlike \(error)")
                completion(response: nil, error: error)
        })
    }

    
    
    func updateTweet(text: String, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        let params = ["status" : text]
        
        POST("1.1/statuses/update.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
            let newTweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: newTweet, error: nil)
            
            }, failure: { (operation: AFHTTPRequestOperation?, error: NSError!) -> Void in
                print("error updating tweet \(error)")
                completion(tweet: nil, error: error)
        })
    }
    
    func replyTweet(text: String, originalId: NSNumber, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        
        var params = [String : AnyObject]()
        params["status"] = text
        params["in_reply_to_status_id"] = originalId
        
        POST("1.1/statuses/update.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let newTweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: newTweet, error: nil)
    
            }, failure: { (operation: AFHTTPRequestOperation?, error: NSError!) -> Void in
                print("error reply tweet \(error)")
                completion(tweet: nil, error: error)
        })
    }
}
