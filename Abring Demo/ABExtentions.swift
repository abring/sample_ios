//
//  extentions.swift
//  octopus
//
//  Created by Hosein on 2/16/1396 AP.
//  Copyright © 1396 AP Sanjaqak. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func presentLogin(style : LoginViewStyle , delegate: UIViewController) {
        let loginVc = ABLoginViewController()
        loginVc.style = style
        loginVc.modalPresentationStyle = .overCurrentContext
        loginVc.delegate = delegate as? AbLoginDelegate
        self.present(loginVc, animated: false, completion: nil)
    }
}

extension UIView {
    func showOverlayError(_ errorType : ABErrorType) {
        let redView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        redView.backgroundColor = UIColor.red.withAlphaComponent(0.9)
        redView.alpha = 0
        self.addSubview(redView)
        
        let label = UILabel(frame: redView.frame)
        if ABAppConfig.font != nil {
            label.font = ABAppConfig.font
        }
        label.textAlignment = .center
        label.textColor = UIColor.white
        
        switch errorType {
        case .invalidToken:
            label.text = "برای استفاده از این امکان باید حتما لاگین باشید"
        case .noConnection:
            label.text = "به اینترنت متصل نیستید"
        case .serverError:
            label.text = "خطا در سرور"
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
        let formatter: NumberFormatter = NumberFormatter()
        formatter.locale = Locale(identifier: "EN")
        let final = formatter.number(from: self)
        
        if final != nil{
            return "0\(final!)"
        } else {
            return nil
        }
    }
}











