//
//  extentions.swift
//  octopus
//
//  Created by Hosein Abbaspour on 2/16/1396 AP.
//  Copyright © 1396 AP Sanjaqak. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    /// Abring login popup. It's UIViewController extension.
    public func presentLogin(style : ABRLoginViewStyle , delegate: UIViewController) {
        let loginVc = ABRLoginViewController()
        loginVc.style = style
        loginVc.modalPresentationStyle = .overCurrentContext
        loginVc.delegate = delegate as? ABRLoginDelegate
        self.present(loginVc, animated: false, completion: nil)
    }
    
    /// Abring login page will be present if ABRPlayer.current() is nil.
    public func loginIfNeeded(storyBoard : String , rootIdentifier : String , backgroundColor : UIColor = .white , backgroundImage : UIImage? = nil) {
        if UserDefaults.standard.integer(forKey: "abinitial") == 0 {
            print("f")
//            let loginVc = UIStoryboard(name: storyBoard, bundle: Bundle.main).instantiateViewController(withIdentifier: rootIdentifier) as! ABRFullScreenLoginViewController
            let loginVc = ABRFullScreenLoginViewController(nibName: "ABRFSLogin", bundle: Bundle(for: ABRFullScreenLoginViewController.self))
            loginVc.backgroundColor = backgroundColor
            loginVc.backgroundImage = backgroundImage

            ABRUtils.topViewController?.present(loginVc, animated: false, completion: nil)
            
        }
    }
}

//extension AppDelegate {
//    func loginIfNeeded(storyBoard : String , rootIdentifier : String , backgroundColor : UIColor = .white , backgroundImage : UIImage? = nil) {
//        if UserDefaults.standard.integer(forKey: "abinitial") == 0 {
//            window = UIWindow(frame: UIScreen.main.bounds)
//            let loginVc = ABRFullScreenLoginViewController()
//            loginVc.backgroundColor = backgroundColor
//            loginVc.backgroundImage = backgroundImage
//            loginVc.identifier = rootIdentifier
//            loginVc.storyBoard = storyBoard
//            window?.rootViewController = loginVc
//            window?.makeKeyAndVisible()
//        }
//    }
//}



extension UIView {
    func showOverlayError(_ errorType : ABRErrorType) {
        let redView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        redView.backgroundColor = UIColor.red.withAlphaComponent(0.9)
        redView.alpha = 0
        self.addSubview(redView)
        
        let label = UILabel(frame: redView.frame)
        if ABRAppConfig.font != nil {
            label.font = ABRAppConfig.font
        }
        label.textAlignment = .center
        label.textColor = UIColor.white
        
        switch errorType {
        case .invalidToken:
            label.text = "برای استفاده از این امکان باید حتما لاگین باشید"
        case .noConnection:
            label.text = ABRAppConfig.loginErrorTexts.noConnection
        case .serverError:
            label.text = ABRAppConfig.loginErrorTexts.serverError
        default:
            label.text = "مشکلی پیش آمد\nدوباره سعی کنید"
        }
        
        label.numberOfLines = 0
        
        redView.addSubview(label)
        
        UIView.animate(withDuration: 0.3) {
            redView.alpha = 1
        }
        
        UIView.animate(withDuration: 0.9, delay: 0.3, options: .curveLinear, animations: {
            redView.alpha = 0
        }) { (_) in
            redView.removeFromSuperview()
        }
    }
}




extension UIColor {
    convenience init(hex: String , alpha : Float) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        let a = alpha
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff,
            alpha: CGFloat(a)
        )
    }
}





extension String {
    func englishNumbers() -> String? {
        let oldCount = self.characters.count
        let formatter: NumberFormatter = NumberFormatter()
        formatter.locale = Locale(identifier: "EN")
        
        if let final = formatter.number(from: self) {
            let newCount = "\(final)".characters.count
            let differ = oldCount - newCount
            if differ == 0 {
                return "\(final)"
            } else {
                var outFinal = "\(final)"
                for _ in 1...differ {
                    outFinal = "0" + outFinal
                }
                return outFinal
            }
        } else {
            return nil
        }
    }
    
    func persianDateWith(format : String) -> String? {
        let persianCal = Calendar(identifier: .persian)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fa_IR")
        formatter.calendar = persianCal
        formatter.dateFormat = format
        if let interval = Double(self) {
            let date = Date(timeIntervalSince1970: interval)
            return formatter.string(from: date)
        } else {
            return nil
        }
    }
}











