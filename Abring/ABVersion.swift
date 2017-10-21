//
//  ABVersion.swift
//  Pouya
//
//  Created by Hosein on 4/28/1396 AP.
//  Copyright © 1396 AP AsemanLTD. All rights reserved.
//

import Foundation


public struct ABVersion : Equatable {
    
    var versionString : String
    var major : Int?
    var mid : Int?
    var minor : Int?

    
    
    //MARK: init methods
    
    init(_ version : String) {
        self.versionString = version
        
        let versionComponents = versionString.components(separatedBy: ".")
        major = Int(versionComponents.first ?? "0")
        if versionComponents.count > 1 {
            mid = Int(versionComponents[1])
        }
        if versionComponents.count > 2 {
            minor = Int(versionComponents[2])
        }
    }
    
    
    //MARK: other methods
    
    // Call this method for checking if there is any update available or not ,
    // You must have a variable named 'update' in your app date in Abring Panel
    // set update variable like this: 
//    {
//        "ios" : {
//            "current" : "1.3" ,
//            "force" : "1.2" ,
//            "link" : "http://downloadUrl.com"
//        }
//    }
    
    // in above example current is the latest version of your app that is live now
    // force is the minimum version that user can run your app
    // link is the url for downloading your app, for example you can use appstore link
    
    public static func checkForUpdate() {
        ABApp.get { (success, _ , app) in
            if success {
                let vc = ABNewVersionViewController(nibName: "NewVersion", bundle: Bundle.main)
                vc.modalPresentationStyle = .overCurrentContext
                vc.app = app
                let bundleVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
                if let current = app?.currentVersion {
                    if current > ABVersion(bundleVersion) {
                        if ABVersion(bundleVersion) < (app?.minimumVersion)! {
                            // force update
                            vc.isForce = true
                            ABUtils.topViewController?.present(vc, animated: true, completion: nil)
                        } else {
                            if let ver = app?.currentVersion?.versionString {
                                let savedVer = UserDefaults.standard.bool(forKey: ver)
                                if !savedVer {
                                    // normal update
                                    print("update available")
                                    ABUtils.topViewController?.present(vc, animated: true, completion: nil)
                                }
                            }
                        }
                    } else {
                        print("Abring : Your app is up to date")
                    }
                } else {
                    print("Abring : Define update variable in your appdata in Abring Panel")
                }

            } else {
                print("Abring : Couldn't check for update")
            }
        }
    }
    
    //MARK: Operators
    
    public static func ==(lhs: ABVersion, rhs: ABVersion) -> Bool {
        if lhs.minor == nil || rhs.minor == nil {
            return (lhs.major == rhs.major) && (lhs.mid == rhs.mid)
        } else {
            return (lhs.major == rhs.major) && (lhs.mid == rhs.mid) && (lhs.minor == rhs.minor)
        }
        
    }
    
    public static func >(lhs: ABVersion, rhs: ABVersion) -> Bool {
        return lhs.major ?? 0 > rhs.major ?? 0 ||
            lhs.major == rhs.major && lhs.mid ?? 0 > rhs.mid ?? 0 ||
            lhs.major == rhs.major && lhs.mid == rhs.mid && lhs.minor ?? 0 > rhs.minor ?? 0
    }
    
    public static func <(lhs: ABVersion, rhs: ABVersion) -> Bool {
        return lhs.major ?? 0 < rhs.major ?? 0 ||
            lhs.major == rhs.major && lhs.mid ?? 0 < rhs.mid ?? 0 ||
            lhs.major == rhs.major && lhs.mid == rhs.mid && lhs.minor ?? 0 < rhs.minor ?? 0
    }
    
    public static func >=(lhs: ABVersion, rhs: ABVersion) -> Bool {
        return (lhs.major ?? 0 > rhs.major ?? 0 ||
            lhs.major == rhs.major && lhs.mid ?? 0 > rhs.mid ?? 0 ||
            lhs.major == rhs.major && lhs.mid == rhs.mid && lhs.minor ?? 0 > rhs.minor ?? 0) ||
            ((lhs.major == rhs.major) && (lhs.mid == rhs.mid) && (lhs.minor == rhs.minor))
    }
    
    public static func <=(lhs: ABVersion, rhs: ABVersion) -> Bool {
        return (lhs.major ?? 0 < rhs.major ?? 0 ||
            lhs.major == rhs.major && lhs.mid ?? 0 < rhs.mid ?? 0 ||
            lhs.major == rhs.major && lhs.mid == rhs.mid && lhs.minor ?? 0 < rhs.minor ?? 0) ||
            ((lhs.major == rhs.major) && (lhs.mid == rhs.mid) && (lhs.minor == rhs.minor))
    }
    
}


