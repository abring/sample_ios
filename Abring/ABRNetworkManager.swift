//
//  ABManager.swift
//  abringTest
//
//  Created by Hosein Abbaspour on 5/3/1396 AP.
//  Copyright © 1396 AP Sanjaqak. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

@objc public enum ABRErrorType : Int {
    case invalidToken
    case serverError
    case noConnection
    case unknownError
}

struct ABRNetworkManager {
    static func request(_ url : String , tokenNeeded : Bool , parameters : [String : Any]? ,completion : @escaping (_ responseJSON : JSON? , _ errorType : ABRErrorType?) -> Void) {
        assert(ABRAppConfig.name != nil, "You must set the app name: ABAppConfig.name = YOURAPPNAME")
        var finalParameters : Parameters = [
            "app": ABRAppConfig.name!
        ]
        if tokenNeeded {
            let token = ABRPlayer.current()?.token
            assert(token != nil, "Token is nil")
            finalParameters["token"] = ABRPlayer.current()?.token!
        }
        if parameters != nil {
            for (key , value) in parameters! {
                finalParameters[key] = value
            }
        }
        if !NetworkReachabilityManager()!.isReachable {
            completion(nil, ABRErrorType.noConnection)
            return
        }
        Alamofire.request(url ,
                          method: .post ,
                          parameters: finalParameters ,
                          encoding: URLEncoding.default).validate().responseJSON { response in
                            switch response.result {
                            case .success(let value):
                                let json = JSON(value)
                                print(json)
                                switch json["code"].string ?? "" {
                                case "200" :
                                    completion(json["result"], nil)
                                case "401" :
                                    //WARNING: incomplete
                                    completion(nil, ABRErrorType.invalidToken)
                                default :
                                    completion(nil, ABRErrorType.unknownError)
                                }
                            case .failure(let error):
                                if response.response?.statusCode == 500 {
                                    completion(nil, ABRErrorType.serverError)
                                }
                                print(error)
                            }
        }

    }
}
