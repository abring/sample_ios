//
//  AbConfiguration.swift
//  KhabarVarzeshi
//
//  Created by Hosein Abbaspour on 3/22/1396 AP.
//  Copyright © 1396 AP Sanjaqak. All rights reserved.
//

import Foundation
import UIKit

/// Configure your app with this property.
public let ABRAppConfig = ABRConfiguration.shared


public enum ABRPlayerProperty : String {
    case name = "نام"
    case mobile = "شماره موبایل"
    case sex = "جنیست"
    case birth = "تاریخ تولد"
    case mail = "پست الکترونیک"

}

public class ABRConfiguration {
  
    
    public var playerIncludes : [ABRPlayerProperty]?
    public var playerHasAvatar = true
    
    public static let shared = ABRConfiguration()
    
    /// If you'll use Abring custom UIs, this font will be set.
    public var font : UIFont?
    
    /// Your App id that you got in Abring panel. You must set it or app will crash.
    public var name : String?
    
    /// The main color for UIs tint color and some view backgrounds color in Abring UI.
    public var tintColor : UIColor = UIColor.gray
    
    /// The main button in Abring login view.
    public var mainButton : UIButton!
    
    /// If set to false you should handle UIs for errors via `errorOccoured(_:)` in ABRLoginDelegate protocol.
    public var loginHasBuiltinErrorMessages = true
    
    /// Secondary button in Abring login view. buttons like resend code.
    public var secondaryButton : UIButton!
    
    
    public var textField : ABRUITextField!
    
    /// All the textfield placeholders in Abring UI are in this.
    public var textFieldsPlaceHolders = ABRUITextFieldsPlaceHolders()

    /// Labels color. default is gray.
    public var labelsColor = UIColor(white: 0, alpha: 0.3)
    
    /// All the button titles in Abring UI are in this.
    public var buttonsTitles = ABRUIButtonsTitles()
    
    /// All the texts in Abring UI are in this, texts like titles and descriptions in login view.
    public var texts = ABRUITexts()
    
    /// You can set `ABRAppConfig.loginHasBuiltinErrorMessages` to false and handle your own custom UI for error messages via `ABRLoginDelegate`.
    public var loginErrorTexts = ABRLoginErrorMessages()
    
    // Prevent default initialization
    private init() {
    }
}

/// To change these in Abring UI use: ABRAppConfig.ABRUITextFieldsPlaceHolders
public class ABRUITextFieldsPlaceHolders {
    public var phoneTextFieldPlaceHolder = "09xxxxxxxxx"
    public var codeTextFieldPlaceHolder = "کد را وارد کنید"
    
}

/// To change these in Abring UI use: ABRAppConfig.ABRUIButtonsTitles
public class ABRUIButtonsTitles {
    public var loginSendCodeToPhoneButtonTitle = "ارسال کد"
    public var loginOtherWaysButtonTitle = "راه‌های دیگر"
    public var loginConfirmCodeButtonTitle = "ورود به حساب"
    public var updateDownloadButtonTitle = "دریافت نسخه جدید"
    public var updateLaterButtonTitle = "بعدا دریافت میکنم"
}

/// To change these in Abring UI use: ABRAppConfig.ABRUITexts
public class ABRUITexts {
    public var inputPhoneText = "شماره تلفن‌همراه خود را وارد کنید\nدر صورت نیاز از سایر روش‌ها استفاده کنید"
    public var inputCodeText = "کد برای شما ارسال شد\nلطفا با دقت در کادر زیر وارد کنید"
}

public class ABRLoginErrorMessages {
    public var noConnection = "خطا در شبکه. لطفا وضعیت دسترسی به اینترنت را بررسی کنید"
    public var serverError = "خطا در سرور. لطفا بعدا سعی کنید"
}

public class ABRUIButton {
    public var cornerRadius : CGFloat = 4
    public var backgroundColor = ABRAppConfig.tintColor
}

public class ABRUITextField : UITextField {

    override public func draw(_ rect: CGRect) {
        self.borderStyle = .none
        self.font = ABRAppConfig.font
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

struct ABRUtils {
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

struct ABRWebserviceURLs {
    static let requestCode = "http://ws.v3.abring.ir/index.php?r=player/mobile-register"
    static let resendCode = "http://ws.v3.abring.ir/index.php?r=player/mobile-resend-code"
    static let logout = "http://ws.v3.abring.ir/index.php?r=player/logout"
    static let verifyCode = "http://ws.v3.abring.ir/index.php?r=player/mobile-verify"
    static let analyticSet = "http://ws.v3.abring.ir/index.php?r=analytic/set"
    static let appGet = "http://ws.v3.abring.ir/index.php?r=app/get"
    static let playerSet = "http://ws.v3.abring.ir/index.php?r=player/set"
    static let playerGet = "http://ws.v3.abring.ir/index.php?r=player/get"
}
