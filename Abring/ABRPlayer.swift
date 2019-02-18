//
//  User.swift
//  Peykfood
//
//  Created by Hosein Abbaspour on 2/5/1396 AP.
//  Copyright © 1396 AP Sanjaqak. All rights reserved.
//

import Foundation
import SwiftyJSON


public enum ABRSex: String {
    case male = "male"
    case female = "female"
    case notSet
    
    var persian : String
    {
        get
        {
            switch self {
            case .male:
                return "مرد"
            case .female:
                return "زن"
            case .notSet:
                return "تعریف نشده"
            }
        }
    }
}


public class ABRPlayer : NSObject , NSCoding {
    public typealias LoginCompletionBlock =  (_ success: Bool, _ errorType: ABRErrorType?) -> Void

    public var id : String
    public var token : String?
    public var mobile : String?
    public var avatarUrl : String?
    public var sex : ABRSex?
    public var mail : String?
    public var name : String?
    public var likesArray : [String]?
    public var pollsArray : [String]?
    public var friendRequests : [String]?
    public var friendInvitations : [String]?
    public var birthdayTimestamp : String?
    
    var variables : [String : Any]?
    
    
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
        let birthdayTimestamp = aDecoder.decodeObject(forKey: "birthdayTimestamp") as? String
        let name = aDecoder.decodeObject(forKey: "name") as? String
        let likesArray = aDecoder.decodeObject(forKey: "likesArray") as? [String]
        let pollsArray = aDecoder.decodeObject(forKey: "pollsArray") as? [String]
        let requests = aDecoder.decodeObject(forKey: "requests") as? [String]
        let invits = aDecoder.decodeObject(forKey: "invits") as? [String]
        let fields = aDecoder.decodeObject(forKey: "fields") as? [String : Any]


        
        
        self.init(withID: id)
        self.mobile = phone
        self.token = token
        self.avatarUrl = avatarUrl
        self.sex = ABRSex(rawValue: sex)
        self.mail = mail
        self.name = name
        self.birthdayTimestamp = birthdayTimestamp
        self.likesArray = likesArray
        self.pollsArray = pollsArray
        self.friendRequests = requests
        self.friendInvitations = invits
        self.variables = fields
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "userId")
        aCoder.encode(mobile, forKey: "phoneNumber")
        aCoder.encode(token, forKey: "token")
        aCoder.encode(avatarUrl, forKey: "avatarUrl")
        aCoder.encode(sex?.rawValue , forKey: "sex")
        aCoder.encode(mail, forKey: "mail")
        aCoder.encode(birthdayTimestamp, forKey: "birthdayTimestamp")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(likesArray, forKey: "likesArray")
        aCoder.encode(pollsArray, forKey: "pollsArray")
        aCoder.encode(friendRequests, forKey: "requests")
        aCoder.encode(friendInvitations, forKey: "invits")
        aCoder.encode(variables, forKey: "fields")
    }

    
    func passProperty(key : ABRPlayerProperty) -> String? {
        switch key {
        case .name:
            return self.name
        case .mobile:
            return self.mobile
        case .sex:
            return self.sex?.persian
        case .birth:
            return birthdayTimestamp?.persianDateWith(format: "YYYY MMMM d")
        case .mail:
            return self.mail
        }
    }

    
   public class func requestRegisterCode(phoneNumber : String , completion :  @escaping LoginCompletionBlock) {
        let parameters : [String : Any] = [
            "mobile": phoneNumber
        ]
    ABRNetworkManager.request(ABRWebserviceURLs.requestCode, tokenNeeded: false, parameters: parameters) { (json , errorType) in
            if json != nil {
                completion(true, nil)
            } else {
                completion(false, errorType)
            }
        }
    }
    
    
    public class func resendRegisterCode(phoneNumber : String , completion :  @escaping LoginCompletionBlock) {
        let parameters : [String : Any] = [
            "mobile": phoneNumber
        ]
        ABRNetworkManager.request(ABRWebserviceURLs.resendCode, tokenNeeded: false, parameters: parameters) { (json , errorType) in
            if json != nil {
                completion(true, nil)
            } else {
                completion(false, errorType)
            }
        }
    }
    
    
    
    public class func verifyRegisterCode(phoneNumber : String , code : String , completion :  @escaping (_ success: Bool,_ player : ABRPlayer? , _ errorType: ABRErrorType?) -> Void) {
        let parameters : [String : Any] = [
            "mobile": phoneNumber ,
            "code" : code
        ]
        
        ABRNetworkManager.request(ABRWebserviceURLs.verifyCode, tokenNeeded: false, parameters: parameters) { (json , errorType) in
            if let json = json {
                let player = ABRPlayer(withID: json["player_id"].string!)
                player.token = json["token"].string
                player.name = json["player_info"]["name"].string
                player.sex = json["player_info"]["sex"].string != nil ? ABRSex(rawValue: json["player_info"]["sex"].string!) : ABRSex.notSet
                player.mail = json["player_info"]["email"].string
                player.avatarUrl = json["player_info"]["avatar"].string
                player.mobile = json["player_info"]["mobile"].string
                player.variables = json.dictionaryObject
                
                
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
    
    
    public class func set(paramters : [String : Any] , completion :  @escaping (_ success: Bool, _ errorType: ABRErrorType?) -> Void) {
        ABRNetworkManager.request(ABRWebserviceURLs.playerSet, tokenNeeded: true, parameters: paramters) { (json, errorType) in
            if let _ = json {
                completion(true, nil)
            } else {
                completion(false, errorType)
            }
        }
    }
    
    
    public class func get(completion :  @escaping (_ success: Bool,_ player : ABRPlayer? , _ errorType: ABRErrorType?) -> Void) {
        ABRNetworkManager.request(ABRWebserviceURLs.playerGet, tokenNeeded: true, parameters: nil) { (json , errorType) in
            if let json = json {
                let player = ABRPlayer(withID: json["player_id"].string!)
                player.token = json["token"].string
                player.name = json["player_info"]["name"].string
                player.sex = json["player_info"]["sex"].string == "man" ? ABRSex.male : ABRSex.female
                player.mail = json["player_info"]["email"].string
                player.avatarUrl = json["player_info"]["avatar"].string
                player.mobile = json["player_info"]["mobile"].string
                player.variables = json.dictionaryObject
                
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
    
    
    public class func logout(completion : @escaping LoginCompletionBlock) {
        ABRNetworkManager.request(ABRWebserviceURLs.logout, tokenNeeded: true, parameters: nil) { (json , errorType) in
            if json != nil {
                UserDefaults.standard.removeObject(forKey: "abplayer")
                UserDefaults.standard.synchronize()
                completion(true, nil)
            } else {
                completion(false, errorType)
            }
        }
    }
    
    
    public class func current() -> ABRPlayer? {
        if let data = UserDefaults.standard.data(forKey: "abplayer") {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? ABRPlayer
        } else {
            return nil
        }
    }
    
    static func save() {
        let user = ABRPlayer.current()
        if let user = user {
            let userDefaults = UserDefaults.standard
            let encodedData : Data = NSKeyedArchiver.archivedData(withRootObject: user)
            userDefaults.set(encodedData, forKey: "abplayer")
            userDefaults.synchronize()
        }
    }

}


