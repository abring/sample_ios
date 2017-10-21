//
//  AbConfiguration.swift
//  KhabarVarzeshi
//
//  Created by Hosein on 3/22/1396 AP.
//  Copyright © 1396 AP Sanjaqak. All rights reserved.
//

import Foundation
import UIKit


public let ABAppConfig = ABConfiguration.shared


public enum ABPlayerProperty : String {
    case name = "نام"
    case mobile = "شماره موبایل"
    case sex = "جنیست"
    case birth = "تاریخ تولد"
    case mail = "پست الکترونیک"

}

public class ABConfiguration {
  
    
    public var playerIncludes : [ABPlayerProperty]?
    public var playerHasAvatar = true
    
    public static let shared = ABConfiguration()
    
    
    public var font : UIFont?
    public var name : String?
    public var tintColor : UIColor? = UIColor.gray
    
    public var mainButton : UIButton!
    public var secondaryButton : UIButton!
    public var textField : TextField!
    public var textFieldsPlaceHolders = TextFieldsPlaceHolders()

    public var labelsColor = UIColor(white: 0, alpha: 0.3)
    
    public var buttonsTitles = ButtonsTitles()
    
    public var texts = Texts()
    
    // Prevent default initialization
    private init() {
    }
}

public class TextFieldsPlaceHolders {
    var phoneTextFieldPlaceHolder = "09xxxxxxxxx"
    var codeTextFieldPlaceHolder = "کد را وارد کنید"
    
}

public class ButtonsTitles {
    var loginSendCodeToPhoneButtonTitle = "ارسال کد"
    var loginOtherWaysButtonTitle = "راه‌های دیگر"
    var loginConfirmCodeButtonTitle = "ورود به حساب"
    var updateDownloadButtonTitle = "دریافت نسخه جدید"
    var updateLaterButtonTitle = "بعدا دریافت میکنم"
}

public class Texts {
    var inputPhoneText = "شماره تلفن‌همراه خود را وارد کنید\nدر صورت نیاز از سایر روش‌ها استفاده کنید"
    var inputCodeText = "کد برای شما ارسال شد\nلطفا با دقت در کادر زیر وارد کنید"
}

public class Button {
    var cornerRadius : CGFloat = 4
    var backgroundColor = ABAppConfig.tintColor
}

public class TextField : UITextField {

    override public func draw(_ rect: CGRect) {
        self.borderStyle = .none
        self.font = ABAppConfig.font
        self.textAlignment = .center
        
        createBorder()
    }
    
    func createBorder() {
        let border = CALayer()
        border.borderWidth = 1.0
        border.frame = CGRect(x: 0, y: self.frame.size.height - 1 , width: self.frame.size.width, height: 1)
        border.borderColor = UIColor(white: 0, alpha: 0.1).cgColor
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
}

struct ABUtils {
    static var topViewController: UIViewController?{
        let keyWindow = UIApplication.shared.keyWindow
        if keyWindow?.rootViewController == nil{
            return keyWindow?.rootViewController
        }
        
        var pointedViewController = keyWindow?.rootViewController
        
        while  pointedViewController?.presentedViewController != nil {
            switch pointedViewController?.presentedViewController {
            case let navagationController as UINavigationController:
                pointedViewController = navagationController.viewControllers.last
            case let tabBarController as UITabBarController:
                pointedViewController = tabBarController.selectedViewController
            default:
                pointedViewController = pointedViewController?.presentedViewController
            }
        }
        return pointedViewController
        
    }
}

struct WebserviceURL {
    static let requestCode = "http://ws.v3.abring.ir/index.php?r=player/mobile-register"
    static let resendCode = "http://ws.v3.abring.ir/index.php?r=player/mobile-resend-code"
    static let logout = "http://ws.v3.abring.ir/index.php?r=player/logout"
    static let verifyCode = "http://ws.v3.abring.ir/index.php?r=player/mobile-verify"
    static let analyticSet = "http://ws.v3.abring.ir/index.php?r=analytic/set"
    static let appGet = "http://ws.v3.abring.ir/index.php?r=app/get"
    static let playerSet = "http://ws.v3.abring.ir/index.php?r=player/set"
    static let playerGet = "http://ws.v3.abring.ir/index.php?r=player/get"
}
