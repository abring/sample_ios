//
//  ABManager.swift
//  abringTest
//
//  Created by Hosein on 5/3/1396 AP.
//  Copyright © 1396 AP Sanjaqak. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum ABErrorType {
    case invalidToken
    case serverError
    case noConnection
    case unknownError
}

struct ABManager {
    static func request(_ url : String , tokenNeeded : Bool , parameters : [String : Any]? ,completion : @escaping (_ responseJSON : JSON? , _ errorType : ABErrorType?) -> Void) {
        assert(ABAppConfig.name != nil, "You must set the app name: ABAppConfig.name = YOURAPPNAME")
        var finalParameters : Parameters = [
            "app": ABAppConfig.name!
        ]
        if tokenNeeded {
            let token = ABPlayer.currentPlayer()?.token
            assert(token != nil, "Token is nil")
            finalParameters["token"] = ABPlayer.currentPlayer()?.token!
        }
        if parameters != nil {
            for (key , value) in parameters! {
                finalParameters[key] = value
            }
        }
        if !NetworkReachabilityManager()!.isReachable {
            completion(nil, ABErrorType.noConnection)
            return
        }
        Alamofire.request(url ,
                          method: .post ,
                          parameters: parameters ,
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
                                    completion(nil, ABErrorType.invalidToken)
                                default :
                                    completion(nil, ABErrorType.unknownError)
                                }
                            case .failure(let error):
                                if response.response?.statusCode == 500 {
                                    completion(nil, ABErrorType.serverError)
                                }
                                print(error)
                            }
        }

    }
}
