//
//  ABVersion.swift
//  Pouya
//
//  Created by Hosein Abbaspour on 4/28/1396 AP.
//  Copyright © 1396 AP AsemanLTD. All rights reserved.
//

import Foundation

/**
 Make an instance of this class from version in string format.
 All the main operations like == != etc are supported.
*/

public struct ABRVersion : Equatable {
    
    /// Version in string format.
    public var versionString : String
    
    /// Major part of version. for example 2 in 2.3.4
    public var major : Int?
    
    /// Middle part of version. for example 3 in 2.3.4
    public var mid : Int?
    
    /// Minor part of version. for example 4 in 2.3.4
    public var minor : Int?

    
    
    //MARK: init methods
    
    /// Set your version in string as parameter like `1.1.2`
    public init(_ version : String) {
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
    /**
     The main method for checking if there is new version of your app available.
     ## Usage
     You must have a variable named 'update' in your app data in your [Abring](http://abring.ir) Panel.
     Set update variable like this:
     {
     ````
     "ios" : {
         "current" : "1.3" ,
         "force" : "1.2" ,
         "link" : "http://downloadUrl.com"
         }
     }
     ````
     In above example current is the latest version of your app that is live now.
     Force is the minimum version that user can run your app.
     Link is the url for downloading your app, for example you can use appstore link.
    */
    public static func checkForUpdate() {
        ABRApp.get { (success, _ , app) in
            if success {
                var vc : ABRNewVersionViewController!
                if Bundle.main.path(forResource: "ABRNewVersion", ofType: "nib") != nil {
                    print("found xib main bundle")
                    vc = ABRNewVersionViewController(nibName: "ABRNewVersion", bundle: Bundle.main)
                } else {
                    vc = ABRNewVersionViewController(nibName: "ABRNewVersion", bundle: Bundle.init(for: ABRNewVersionViewController.self))
                }
                vc.modalPresentationStyle = .overCurrentContext
                vc.app = app
                let bundleVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
                if let current = app?.currentVersion {
                    if current > ABRVersion(bundleVersion) {
                        if ABRVersion(bundleVersion) < (app?.minimumVersion)! {
                            // force update
                            vc.isForce = true
                            ABRUtils.topViewController?.present(vc, animated: true, completion: nil)
                        } else {
                            if let ver = app?.currentVersion?.versionString {
                                let savedVer = UserDefaults.standard.bool(forKey: ver)
                                if !savedVer {
                                    // normal update
                                    print("Abring : Update available")
                                    ABRUtils.topViewController?.present(vc, animated: true, completion: nil)
                                } else {
                                    print("Abring : Update View Controller has been shown before")
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
    
    public static func ==(lhs: ABRVersion, rhs: ABRVersion) -> Bool {
        if lhs.minor == nil || rhs.minor == nil {
            return (lhs.major == rhs.major) && (lhs.mid == rhs.mid)
        } else {
            return (lhs.major == rhs.major) && (lhs.mid == rhs.mid) && (lhs.minor == rhs.minor)
        }
        
    }
    
    public static func >(lhs: ABRVersion, rhs: ABRVersion) -> Bool {
        return lhs.major ?? 0 > rhs.major ?? 0 ||
            lhs.major == rhs.major && lhs.mid ?? 0 > rhs.mid ?? 0 ||
            lhs.major == rhs.major && lhs.mid == rhs.mid && lhs.minor ?? 0 > rhs.minor ?? 0
    }
    
    public static func <(lhs: ABRVersion, rhs: ABRVersion) -> Bool {
        return lhs.major ?? 0 < rhs.major ?? 0 ||
            lhs.major == rhs.major && lhs.mid ?? 0 < rhs.mid ?? 0 ||
            lhs.major == rhs.major && lhs.mid == rhs.mid && lhs.minor ?? 0 < rhs.minor ?? 0
    }
    
    public static func >=(lhs: ABRVersion, rhs: ABRVersion) -> Bool {
        return (lhs.major ?? 0 > rhs.major ?? 0 ||
            lhs.major == rhs.major && lhs.mid ?? 0 > rhs.mid ?? 0 ||
            lhs.major == rhs.major && lhs.mid == rhs.mid && lhs.minor ?? 0 > rhs.minor ?? 0) ||
            ((lhs.major == rhs.major) && (lhs.mid == rhs.mid) && (lhs.minor == rhs.minor))
    }
    
    public static func <=(lhs: ABRVersion, rhs: ABRVersion) -> Bool {
        return (lhs.major ?? 0 < rhs.major ?? 0 ||
            lhs.major == rhs.major && lhs.mid ?? 0 < rhs.mid ?? 0 ||
            lhs.major == rhs.major && lhs.mid == rhs.mid && lhs.minor ?? 0 < rhs.minor ?? 0) ||
            ((lhs.major == rhs.major) && (lhs.mid == rhs.mid) && (lhs.minor == rhs.minor))
    }
    
}


