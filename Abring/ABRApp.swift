//
//  ABApp.swift
//  Pouya
//
//  Created by Hosein Abbaspour on 4/28/1396 AP.
//  Copyright © 1396 AP AsemanLTD. All rights reserved.
//

import Foundation
import SwiftyJSON

/**
 In [Abring](http://abring.ir) panel there's a section named App Data. you can set custom variables there and use them in your app. setting variables is possible only in panel. ABRAPP class has a `variables` dictionary that contains every variables in App data section. you should call get method to access app instance.
 # Example
 ````
 ABRApp.get { (success, errorType, app) in
 let something = app?.variables["something"] as? String
 }
 ````
*/
public class ABRApp {
    /// Latest verion of your app. Read ABRVersion class document for more info.
    public var currentVersion : ABRVersion?
    
    /// Least verion of your app that can run. Read ABRVersion class document for more info.
    public var minimumVersion : ABRVersion?
    
    var versionUrl : String?
    
    /// Your app logo that you set in your panel.
    public var logoUrl : String?
    
    /// Your app name that you set in your panel.
    public var name : String?
    
    /// Use ABRApp.get(_) method to fill this variable.
    public var variables : [String : Any]?
    
    /**
     Use this method to access to your variables in App data.
     # Example
     ````
     ABRApp.get { (success, errorType, app) in
     let something = app?.variables["something"] as? String
     }
     ````
     */
    public class func get(completion : @escaping (_ success : Bool , _ errorType : ABRErrorType? , _ app : ABRApp?) -> Void) {
        ABRNetworkManager.request(ABRWebserviceURLs.appGet, tokenNeeded: false , parameters: nil) { (json, errorType) in
            if json != nil {
                let app = ABRApp()
                if let serverCurrentVersion = json?["update"]["ios"]["current"].string ,
                    let serverMinVersion =  json?["update"]["ios"]["force"].string ,
                    let url = json?["update"]["ios"]["link"].string {
                    app.currentVersion = ABRVersion(serverCurrentVersion)
                    app.minimumVersion = ABRVersion(serverMinVersion)
                    app.versionUrl = url
                }
                app.logoUrl = json?["logo"].string
                app.name = json?["name"].string
                app.variables = json!.dictionaryObject!
                completion(true, nil , app)
            } else {
                completion(false, errorType , nil)
            }
        }
    }
    
    
    
}
