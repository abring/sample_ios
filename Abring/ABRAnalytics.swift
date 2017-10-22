//
//  ABAnalytics.swift
//  Abring Demo
//
//  Created by Hosein on 6/25/1396 AP.
//  Copyright © 1396 AP AsemanLTD. All rights reserved.
//

import Foundation
import SwiftyJSON


public class ABRAnalytics : NSObject {
    class func set(variable : String , completion :  (( _ success : Bool , _ errorType : ABRErrorType?) -> Void)? = nil) {
        ABRNetworkManager.request(ABRWebserviceURLs.analyticSet , tokenNeeded: true, parameters: ["variable" : variable]) { (json, errorType) in
            if errorType != nil {
                completion?(true, nil)
            } else {
                completion?(false, errorType)
            }
        }
    }
    
}
