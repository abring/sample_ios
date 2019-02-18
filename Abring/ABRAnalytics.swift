//
//  ABAnalytics.swift
//  Abring Demo
//
//  Created by Hosein Abbaspour on 6/25/1396 AP.
//  Copyright © 1396 AP AsemanLTD. All rights reserved.
//

import Foundation
import SwiftyJSON

/**
 It's Abring analytics
 
 It has a `set(_:)` method to set a custom variable and then it will appear in you panel in [Abring](http://abring.ir) website.
 ## Note
 After you call set method it may take up to 24 hours to appear in panel. You can use calculate method in your abring panel to sync and update variables.
 
*/

public class ABRAnalytics : NSObject {
    
    /**
     Set custom variable and it will appear in your Abring panel
     
     ## Example
     ````
     ABRAnalytics.set("firstLaunch")
     ````
     
     - parameter variable:
         a custom string variable. It can be anything you like.
     - parameter completion:
         An optional completion. it's useful if you want to handle network errors etc.
     */
    
    public class func set(_ variable : String , completion :  (( _ success : Bool , _ errorType : ABRErrorType?) -> Void)? = nil) {
        ABRNetworkManager.request(ABRWebserviceURLs.analyticSet , tokenNeeded: true, parameters: ["variable" : variable]) { (json, errorType) in
            if errorType != nil {
                completion?(true, nil)
            } else {
                completion?(false, errorType)
            }
        }
    }
    
}
