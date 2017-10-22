//
//  ABApp.swift
//  Pouya
//
//  Created by Hosein on 4/28/1396 AP.
//  Copyright © 1396 AP AsemanLTD. All rights reserved.
//

import Foundation
import SwiftyJSON


public class ABRApp {
    var currentVersion : ABRVersion?
    var minimumVersion : ABRVersion?
    var versionUrl : String?

    public var logoUrl : String?
    public var name : String?
    
    public var variables : [String : Any]?
    
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
