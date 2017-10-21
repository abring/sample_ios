//
//  ABApp.swift
//  Pouya
//
//  Created by Hosein on 4/28/1396 AP.
//  Copyright © 1396 AP AsemanLTD. All rights reserved.
//

import Foundation
import SwiftyJSON


public class ABApp {
    var currentVersion : ABVersion?
    var minimumVersion : ABVersion?
    var versionUrl : String?

    var logoUrl : String?
    var name : String?
    
    var variables : [String : Any]?
    
    public class func get(completion : @escaping (_ success : Bool , _ errorType : ABErrorType? , _ app : ABApp?) -> Void) {
        ABManager.request(WebserviceURL.appGet, tokenNeeded: false , parameters: nil) { (json, errorType) in
            if json != nil {
                let app = ABApp()
                if let serverCurrentVersion = json?["update"]["ios"]["current"].string ,
                    let serverMinVersion =  json?["update"]["ios"]["force"].string ,
                    let url = json?["update"]["ios"]["link"].string {
                    app.currentVersion = ABVersion(serverCurrentVersion)
                    app.minimumVersion = ABVersion(serverMinVersion)
                    app.versionUrl = url
                }
                app.logoUrl = json?["logo"].string
                app.name = json?["name"].string
                
                var appCustomVars = [String : Any]()
                for (k , v) in json! {
                    appCustomVars[k] = v
                }
                
                completion(true, nil , app)
            } else {
                completion(false, errorType , nil)
            }
        }
    }
    
    
    public class func set(parameters : [String : Any] , completion : @escaping (_ success : Bool , _ errorType : ABErrorType?) -> Void) {
        
    }
    
}
