//
//  User.swift
//  twitter
//
//  Created by minh on 11/28/15.
//  Copyright © 2015 minh. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var name: String?
    var screenName: String?
    var profileImageURL: String?
    var tagLine: String?
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImageURL = dictionary["profile_image_url"] as? String
        tagLine = dictionary["description"] as? String
        
    }
    
    func logOut() {
        User.currentUser = nil
        TwitterClient.instance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
        
                if data != nil {
                let dictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                    _currentUser = User(dictionary: dictionary as! NSDictionary)
                }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            
            if (_currentUser != nil)    {
                let data = try! NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: .PrettyPrinted)
                
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
            }
            else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}
