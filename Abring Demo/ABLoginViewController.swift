//
//  AbLoginViewController.swift
//  KhabarVarzeshi
//
//  Created by Hosein on 3/22/1396 AP.
//  Copyright © 1396 AP Sanjaqak. All rights reserved.
//

import UIKit

protocol AbLoginDelegate {
    func userDidLogin(_ player : ABPlayer)
    func userDismissScreen()
}

enum LoginViewStyle {
    case LightBlurBackground
    case ExtraLightBlurBackground
    case DarkBlurBackground
    case DarkenBackground
    case LightenBackground
}

enum LoginType {
    case JustPhone
    case JustUserPass
    case Both
}

class ABLoginViewController: UIViewController {

    
    var style : LoginViewStyle = .DarkenBackground
    
    private var dismissButton : UIButton!
    private var mainScrollView : UIScrollView!
    private var innerScrollView : UIScrollView!
    
    private var phoneTf : UITextField!
    private var codeTf : UITextField!
    
    private var visualEffectBlurView = UIVisualEffectView()

    
    private var loginView : UIView!
    
    private var confirmPhoneBtn = UIButton()
    private var confirmCodeBtn = UIButton()
    private var otherWaysBtn = UIButton()
    

    var delegate : AbLoginDelegate?
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presentAnimation()
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        
        view.isOpaque = false
        view.backgroundColor = UIColor.clear
        
        
        setupDismissButton()
        setupLoginView()
        setupScrollView()
        setupTextField()
        setupButtons()
        setupLabels()

    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            mainScrollView.setContentOffset(CGPoint.init(x: 0, y: keyboardHeight/2), animated: true)
        }
    }
    
    
    
    
    
    
    //MARK: Animations
    
    private func presentAnimation() {
        
        switch style {
        case .DarkenBackground:
            UIView.animate(withDuration: 0.3, animations: {
                self.view.backgroundColor = UIColor(white: 0, alpha: 0.4)
            })
        case .LightenBackground:
            UIView.animate(withDuration: 0.3, animations: {
                self.view.backgroundColor = UIColor(white: 1, alpha: 0.4)
            })
        case .LightBlurBackground:
            visualEffectBlurView.frame = view.bounds
            view.insertSubview(visualEffectBlurView, at: 0)
            visualEffectBlurView.alpha = 1
            UIView.animate(withDuration: 0.3 , animations: { 
                self.visualEffectBlurView.effect = UIBlurEffect(style: .light)
            })
        case .ExtraLightBlurBackground:
            visualEffectBlurView.frame = view.bounds
            view.insertSubview(visualEffectBlurView, at: 0)
            visualEffectBlurView.alpha = 1
            UIView.animate(withDuration: 0.3 , animations: {
                self.visualEffectBlurView.effect = UIBlurEffect(style: .extraLight)
            })
        case .DarkBlurBackground:
            visualEffectBlurView.frame = view.bounds
            view.insertSubview(visualEffectBlurView, at: 0)
            visualEffectBlurView.alpha = 1
            UIView.animate(withDuration: 0.3 , animations: {
                self.visualEffectBlurView.effect = UIBlurEffect(style: .dark)
            })
        }

        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7 , initialSpringVelocity: 20 , options: .curveLinear, animations: {
            self.loginView.transform = .identity
            self.loginView.alpha = 1
        }, completion: nil)
    }
    
    private func dismissAnimation(completion : @escaping () -> Void) {
        
        switch style {
        case .DarkenBackground , .LightenBackground:
            UIView.animate(withDuration: 0.3, animations: {
                self.view.backgroundColor = UIColor.clear
            })
        case .LightBlurBackground , .ExtraLightBlurBackground , .DarkBlurBackground:
            UIView.animate(withDuration: 0.2 , animations: {
                self.visualEffectBlurView.effect = nil
            })
        }
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
            self.loginView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
            self.loginView.alpha = 0
        }, completion: { finished in
            completion()
        })
    }
    
    
    //MARK: setup ui
    
    private func setupTextField() {
        if ABAppConfig.textField != nil {
            phoneTf = ABAppConfig.textField
            phoneTf.frame = CGRect(x: 30, y: loginView.bounds.size.height / 2 - 25, width: loginView.bounds.size.width - 60, height: 30)
            codeTf = ABAppConfig.textField
            codeTf.frame = CGRect(x: loginView.bounds.size.width + 30, y: loginView.bounds.size.height / 2 - 25, width: loginView.bounds.size.width - 60, height: 30)
        } else {
            phoneTf = TextField(frame: CGRect(x: 30, y: loginView.bounds.size.height / 2 - 25, width: loginView.bounds.size.width - 60, height: 30))
            phoneTf.placeholder = ABAppConfig.textFieldsPlaceHolders.phoneTextFieldPlaceHolder
            phoneTf.keyboardType = .phonePad
            
            codeTf = TextField(frame: CGRect(x: loginView.bounds.size.width + 30, y: loginView.bounds.size.height / 2 - 25, width: loginView.bounds.size.width - 60, height: 30))
            codeTf.placeholder = ABAppConfig.textFieldsPlaceHolders.codeTextFieldPlaceHolder
            codeTf.keyboardType = .numberPad
        }
        innerScrollView.addSubview(phoneTf)
        innerScrollView.addSubview(codeTf)
    }
    
    private func setupButtons() {
        if ABAppConfig.mainButton != nil {
            confirmPhoneBtn = ABAppConfig.mainButton
            confirmPhoneBtn.frame = CGRect(x: 30, y: loginView.bounds.size.height - 60 , width: loginView.bounds.size.width - 60 , height: 34)
        } else {
            confirmPhoneBtn = UIButton(type: .system)
            confirmPhoneBtn.frame = CGRect(x: 30, y: loginView.bounds.size.height - 60 , width: loginView.bounds.size.width - 60 , height: 34)
            confirmPhoneBtn.backgroundColor = ABAppConfig.tintColor
            confirmPhoneBtn.layer.cornerRadius = 4
            confirmPhoneBtn.setTitle(ABAppConfig.buttonsTitles.loginSendCodeToPhoneButtonTitle , for: .normal)
            confirmPhoneBtn.tintColor = UIColor.white
            confirmPhoneBtn.titleLabel?.font = ABAppConfig.font
        }
        confirmPhoneBtn.addTarget(self, action: #selector(sendCodeAction), for: .touchUpInside)
        innerScrollView.addSubview(confirmPhoneBtn)

    
        
        if ABAppConfig.mainButton != nil {
            confirmCodeBtn = ABAppConfig.mainButton
            confirmCodeBtn.frame = CGRect(x: loginView.bounds.size.width + 30, y: loginView.bounds.size.height - 60 , width: loginView.bounds.size.width - 60 , height: 34)
        } else {
            confirmCodeBtn = UIButton(type: .system)
            confirmCodeBtn.frame = CGRect(x: loginView.bounds.size.width + 30, y: loginView.bounds.size.height - 60 , width: loginView.bounds.size.width - 60 , height: 34)
            confirmCodeBtn.backgroundColor = ABAppConfig.tintColor
            confirmCodeBtn.layer.cornerRadius = 4
            confirmCodeBtn.setTitle(ABAppConfig.buttonsTitles.loginConfirmCodeButtonTitle , for: .normal)
            confirmCodeBtn.tintColor = UIColor.white
            confirmCodeBtn.titleLabel?.font = ABAppConfig.font
        }
        confirmCodeBtn.addTarget(self, action: #selector(verifyCodeAction), for: .touchUpInside)
        innerScrollView.addSubview(confirmCodeBtn)
        
//        if ABAppConfig.secondaryButton != nil {
//            otherWaysBtn = ABAppConfig.mainButton
//            otherWaysBtn.frame = CGRect(x: 30, y: loginView.bounds.size.height - 80 , width: loginView.bounds.size.width - 60 , height: 34)
//        } else {
//            otherWaysBtn = UIButton(type: .system)
//            otherWaysBtn.frame = CGRect(x: 30, y: loginView.bounds.size.height - 40 , width: loginView.bounds.size.width - 60 , height: 34)
//            otherWaysBtn.backgroundColor = UIColor.clear
//            otherWaysBtn.setTitle(ABAppConfig.buttonsTitles.loginOtherWaysButtonTitle , for: .normal)
//            otherWaysBtn.setTitleColor(ABAppConfig.tintColor, for: .normal)
//            otherWaysBtn.titleLabel?.font = ABAppConfig.font
//        }
//        innerScrollView.addSubview(otherWaysBtn)
        
        
        let backBtn = UIButton(type: .system)
        backBtn.frame = CGRect(x: loginView.bounds.width, y: 4, width: 30, height: 30)
        let img = UIImage(named: "AbringKit.bundle/images/back", in: nil, compatibleWith: nil) ?? UIImage()
        img.withRenderingMode(.alwaysTemplate)
        backBtn.setImage(img, for: .normal)
        backBtn.tintColor = ABAppConfig.tintColor
        backBtn.addTarget(self, action: #selector(backToInputPhone), for: .touchUpInside)
        innerScrollView.addSubview(backBtn)
        
    }
    
    private func setupLabels() {
        let inputPhoneLabel = UILabel(frame: CGRect(x: 10, y: 10, width: loginView.bounds.size.width - 20 , height: 80))
        inputPhoneLabel.text = ABAppConfig.texts.inputPhoneText
        innerScrollView.addSubview(inputPhoneLabel)
        
        let inputCodeLabel = UILabel(frame: CGRect(x: loginView.bounds.size.width + 10, y: 10, width: loginView.bounds.size.width - 20 , height: 80))
        inputCodeLabel.text = ABAppConfig.texts.inputCodeText
        innerScrollView.addSubview(inputCodeLabel)
        
        for label in [inputCodeLabel , inputPhoneLabel] {
            if ABAppConfig.font != nil {
                label.font = UIFont(name: ABAppConfig.font!.fontName, size: ABAppConfig.font!.pointSize - 2)
            }
            
            label.numberOfLines = 3
            label.textColor = ABAppConfig.labelsColor
            label.textAlignment = .center
        }
        

    }
    
    private func setupScrollView() {
        mainScrollView = UIScrollView(frame: view.frame)
        mainScrollView.addSubview(dismissButton)
        mainScrollView.addSubview(loginView)
        mainScrollView.contentSize = view.frame.size
        view.addSubview(mainScrollView)
        
        innerScrollView = UIScrollView(frame: loginView.bounds)
        innerScrollView.contentSize = CGSize(width: loginView.bounds.size.width * 2 , height: loginView.bounds.size.height)
        innerScrollView.showsVerticalScrollIndicator = false
        innerScrollView.showsHorizontalScrollIndicator = false
        innerScrollView.isScrollEnabled = false
        loginView.addSubview(innerScrollView)
    }
    
    
    
    
    private func setupDismissButton() {
        dismissButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
        dismissButton.setTitle(nil, for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissAction), for: .touchDown)
        
        
        view.addSubview(dismissButton)
        view.bringSubview(toFront: dismissButton)
    }
    
    private func setupLoginView() {
        loginView = UIView(frame: CGRect(x: view.bounds.size.width / 2 - 120 ,
                                         y: view.bounds.size.height / 2 - 120 ,
                                         width: 240,
                                         height: 240))
        loginView.backgroundColor = UIColor.white
        loginView.clipsToBounds = true
        loginView.layer.cornerRadius = 10
        view.addSubview(loginView)
        view.bringSubview(toFront: loginView)
        loginView.alpha = 0
        loginView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    
        
        
    }
    
    //MARK: button selectors
    
    @objc private func sendCodeAction() {
        if (phoneTf.text?.characters.count)! == 11 {
            confirmPhoneBtn.setTitle(nil, for: .normal)
            confirmPhoneBtn.isEnabled = false
            let activity = UIActivityIndicatorView(activityIndicatorStyle: .white)
            loginView.addSubview(activity)
            activity.center = confirmPhoneBtn.center
            activity.startAnimating()
            ABPlayer.requestRegisterCode(phoneNumber: phoneTf.text!, completion: { (success, errorType) in
                activity.stopAnimating()
                activity.removeFromSuperview()
                self.confirmPhoneBtn.setTitle(ABAppConfig.buttonsTitles.loginSendCodeToPhoneButtonTitle, for: .normal)
                self.confirmPhoneBtn.isEnabled = true
                if success {
                    self.innerScrollView.setContentOffset(CGPoint(x: self.loginView.bounds.size.width , y:0) , animated: true)
                    self.codeTf.becomeFirstResponder()
                } else {
                    self.loginView.showOverlayError(errorType!)
                    
                }
            })
            
        } else {
            print("Phone number is empty")
            confirmPhoneBtn.shake()
        }
    }
    
    @objc private func verifyCodeAction() {
        if (codeTf.text?.characters.count)! == 5 {
            confirmCodeBtn.setTitle(nil, for: .normal)
            confirmCodeBtn.isEnabled = false
            let activity = UIActivityIndicatorView(activityIndicatorStyle: .white)
            loginView.addSubview(activity)
            loginView.bringSubview(toFront: activity)
            activity.center = CGPoint(x: confirmCodeBtn.center.x - loginView.frame.size.width, y: confirmCodeBtn.center.y)
            activity.startAnimating()
            ABPlayer.verifyRegisterCode(phoneNumber: phoneTf.text!, code: codeTf.text!, completion: { (success, player , errorType) in
                activity.stopAnimating()
                activity.removeFromSuperview()
                self.confirmCodeBtn.setTitle(ABAppConfig.buttonsTitles.loginConfirmCodeButtonTitle, for: .normal)
                self.confirmCodeBtn.isEnabled = true
                if success {
                    self.view.endEditing(true)
                    self.dismissAnimation {
                        self.dismiss(animated: false, completion: nil)
                        self.delegate?.userDidLogin(player!)
                    }
                } else {
                    self.loginView.showOverlayError(errorType!)
                }
            })
            
        } else {
            print("code field's length is not 5")
            confirmCodeBtn.shake()
        }
    }
    
    @objc private func backToInputPhone() {
        innerScrollView.setContentOffset(CGPoint(x: 0 , y: 0), animated: true)
        codeTf.text = nil
        phoneTf.becomeFirstResponder()
    }
    
    
    @objc private func dismissAction() {
        view.endEditing(true)
        dismissAnimation {
            self.dismiss(animated: false, completion: nil)
            self.delegate?.userDismissScreen()
        }
    }
    
    
}




fileprivate extension UIView {
    func shake() {
        let shake = CAKeyframeAnimation(keyPath: "transform.translation.x")
        shake.duration = 0.6
        shake.keyTimes = [0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1]
        shake.values = [-10 , 10 , -10 , 10 , -7 , 7 , -4 , 0]
        self.layer.add(shake, forKey: "shake")
    }
}


