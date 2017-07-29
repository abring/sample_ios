//
//  User.swift
//  Peykfood
//
//  Created by Hosein on 2/5/1396 AP.
//  Copyright © 1396 AP Sanjaqak. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


public enum Gender: String {
    case male = "man"
    case female = "woman"
    
    var persianRaw : String
    {
        get
        {
            switch self {
            case .male:
                return "مرد"
            case .female:
                return "زن"
            }
        }
    }
}


public class ABPlayer : NSObject , NSCoding {
    typealias LoginCompletionBlock =  (_ success: Bool, _ errorType: ABErrorType?) -> Void

    var id : String
    var token : String?
    var phoneNumber : String?
    var avatarUrl : String?
    var sex : Gender?
    var mail : String?
    var name : String?
    var likesArray : [String]?
    var pollsArray : [String]?
    var friendRequests : [String]?
    var friendInvitations : [String]?
    
    init(withID : String) {
        self.id = withID
    }
    
    required convenience public init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "userId") as! String
        let phone = aDecoder.decodeObject(forKey: "phoneNumber") as? String
        let token = aDecoder.decodeObject(forKey: "token") as? String
        let avatarUrl = aDecoder.decodeObject(forKey: "avatarUrl") as? String
        let sex = aDecoder.decodeObject(forKey: "sex") as? String ?? "male"
        let mail = aDecoder.decodeObject(forKey: "mail") as? String
        let name = aDecoder.decodeObject(forKey: "name") as? String
        let likesArray = aDecoder.decodeObject(forKey: "likesArray") as? [String]
        let pollsArray = aDecoder.decodeObject(forKey: "pollsArray") as? [String]
        let requests = aDecoder.decodeObject(forKey: "requests") as? [String]
        let invits = aDecoder.decodeObject(forKey: "invits") as? [String]


        
        
        self.init(withID: id)
        self.phoneNumber = phone
        self.token = token
        self.avatarUrl = avatarUrl
        self.sex = Gender(rawValue: sex)
        self.mail = mail
        self.name = name
        self.likesArray = likesArray
        self.pollsArray = pollsArray
        self.friendRequests = requests
        self.friendInvitations = invits
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "userId")
        aCoder.encode(phoneNumber, forKey: "phoneNumber")
        aCoder.encode(token, forKey: "token")
        aCoder.encode(avatarUrl, forKey: "avatarUrl")
        aCoder.encode(sex?.rawValue , forKey: "sex")
        aCoder.encode(mail, forKey: "mail")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(likesArray, forKey: "likesArray")
        aCoder.encode(pollsArray, forKey: "pollsArray")
        aCoder.encode(friendRequests, forKey: "requests")
        aCoder.encode(friendInvitations, forKey: "invits")
    

    }

    
    class func requestRegisterCode(phoneNumber : String , completion :  @escaping LoginCompletionBlock) {
        let parameters : [String : Any] = [
            "mobile": phoneNumber
        ]
        ABManager.request(WebserviceURL.requestCode, tokenNeeded: false, parameters: parameters) { (json , errorType) in
            if json != nil {
                completion(true, nil)
            } else {
                completion(false, errorType)
            }
        }
    }
    
    
    class func reSendRegisterCode(phoneNumber : String , completion :  @escaping LoginCompletionBlock) {
        let parameters : [String : Any] = [
            "mobile": phoneNumber
        ]
        ABManager.request(WebserviceURL.resendCode, tokenNeeded: false, parameters: parameters) { (json , errorType) in
            if json != nil {
                completion(true, nil)
            } else {
                completion(false, errorType)
            }
        }
    }
    
    
    
    class func verifyRegisterCode(phoneNumber : String , code : String , completion :  @escaping (_ success: Bool,_ player : ABPlayer? , _ errorType: ABErrorType?) -> Void) {
        let parameters : [String : Any] = [
            "mobile": phoneNumber ,
            "code" : code
        ]
        
        ABManager.request(WebserviceURL.verifyCode, tokenNeeded: false, parameters: parameters) { (json , errorType) in
            if let json = json {
                let player = ABPlayer(withID: json["player_id"].string!)
                player.token = json["token"].string
                player.name = json["player_info"]["name"].string
                player.sex = json["player_info"]["sex"].string == "man" ? Gender.male : Gender.female
                player.mail = json["player_info"]["email"].string
                player.avatarUrl = json["player_info"]["avatar"].string
                player.phoneNumber = json["player_info"]["mobile"].string
                
                
                let userDefaults = UserDefaults.standard
                let encodedData : Data = NSKeyedArchiver.archivedData(withRootObject: player)
                userDefaults.set(encodedData, forKey: "abplayer")
                userDefaults.synchronize()
                
                completion(true, player, nil)
            } else {
                completion(false, nil, errorType)
            }
        }

    }
    
    
    class func logout(completion : @escaping LoginCompletionBlock) {
        ABManager.request(WebserviceURL.resendCode, tokenNeeded: true, parameters: nil) { (json , errorType) in
            if json != nil {
                UserDefaults.standard.removeObject(forKey: "abplayer")
                completion(true, nil)
            } else {
                completion(false, errorType)
            }
        }
    }
    
    
    class func currentPlayer() -> ABPlayer? {
        if let data = UserDefaults.standard.data(forKey: "abplayer") {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? ABPlayer
        } else {
            return nil
        }
    }
    

    
}

