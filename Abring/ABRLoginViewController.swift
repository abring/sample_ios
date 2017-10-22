//
//  AbLoginViewController.swift
//  KhabarVarzeshi
//
//  Created by Hosein on 3/22/1396 AP.
//  Copyright © 1396 AP Sanjaqak. All rights reserved.
//

import UIKit

@objc public protocol ABRLoginDelegate {
    func userDidLogin(_ player : ABRPlayer)
    @objc optional func userDismissScreen()
}

public enum ABRLoginViewStyle {
    case lightBlur
    case extraLightBlur
    case darkBlur
    case darken
    case lighten
}

enum LoginType {
    case justPhone
    case justUserPass
    case both
}

class ABRLoginViewController: UIViewController {

    private var inset : CGFloat = 10
    var isFullScreen = false {
        didSet {
            if isFullScreen == true {
                loginView.transform = .identity
                loginView.alpha = 1
                loginView.backgroundColor = .clear
                dismissButton.removeFromSuperview()
                view.backgroundColor = UIColor.white
                loginView.frame.origin.x = 0
                loginView.frame.size.width = view.frame.size.width
                inset = 40
                refreshLayout()
            }
        }
    }
    var style : ABRLoginViewStyle = .darken
    
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
    private var backBtn = UIButton()
    private var inputPhoneLabel : UILabel!
    private var inputCodeLabel : UILabel!
    

    var delegate : ABRLoginDelegate?
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isFullScreen {
            presentAnimation()
        } else {
            
        }
        
        
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
        case .darken:
            UIView.animate(withDuration: 0.3, animations: {
                self.view.backgroundColor = UIColor(white: 0, alpha: 0.4)
            })
        case .lighten:
            UIView.animate(withDuration: 0.3, animations: {
                self.view.backgroundColor = UIColor(white: 1, alpha: 0.4)
            })
        case .lightBlur:
            visualEffectBlurView.frame = view.bounds
            view.insertSubview(visualEffectBlurView, at: 0)
            visualEffectBlurView.alpha = 1
            UIView.animate(withDuration: 0.3 , animations: { 
                self.visualEffectBlurView.effect = UIBlurEffect(style: .light)
            })
        case .extraLightBlur:
            visualEffectBlurView.frame = view.bounds
            view.insertSubview(visualEffectBlurView, at: 0)
            visualEffectBlurView.alpha = 1
            UIView.animate(withDuration: 0.3 , animations: {
                self.visualEffectBlurView.effect = UIBlurEffect(style: .extraLight)
            })
        case .darkBlur:
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
        case .darken , .lighten:
            UIView.animate(withDuration: 0.3, animations: {
                self.view.backgroundColor = UIColor.clear
            })
        case .lightBlur , .extraLightBlur , .darkBlur:
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
        if ABRAppConfig.textField != nil {
            phoneTf = ABRAppConfig.textField
            phoneTf.frame = CGRect(x: 30, y: loginView.bounds.size.height / 2 - 25, width: loginView.bounds.size.width - 60, height: 30)
            codeTf = ABRAppConfig.textField
            codeTf.frame = CGRect(x: loginView.bounds.size.width + 30, y: loginView.bounds.size.height / 2 - 25, width: loginView.bounds.size.width - 60, height: 30)
        } else {
            phoneTf = ABRUITextField(frame: CGRect(x: 30, y: loginView.bounds.size.height / 2 - 25, width: loginView.bounds.size.width - 60, height: 30))
            phoneTf.placeholder = ABRAppConfig.textFieldsPlaceHolders.phoneTextFieldPlaceHolder
            phoneTf.keyboardType = .phonePad
            
            codeTf = ABRUITextField(frame: CGRect(x: loginView.bounds.size.width + 30, y: loginView.bounds.size.height / 2 - 25, width: loginView.bounds.size.width - 60, height: 30))
            codeTf.placeholder = ABRAppConfig.textFieldsPlaceHolders.codeTextFieldPlaceHolder
            codeTf.keyboardType = .numberPad
        }
        innerScrollView.addSubview(phoneTf)
        innerScrollView.addSubview(codeTf)
    }
    
    private func setupButtons() {
        if ABRAppConfig.mainButton != nil {
            confirmPhoneBtn = ABRAppConfig.mainButton
            confirmPhoneBtn.frame = CGRect(x: 30, y: loginView.bounds.size.height - 60 , width: loginView.bounds.size.width - 60 , height: 34)
        } else {
            confirmPhoneBtn = UIButton(type: .system)
            confirmPhoneBtn.frame = CGRect(x: 30, y: loginView.bounds.size.height - 60 , width: loginView.bounds.size.width - 60 , height: 34)
            confirmPhoneBtn.backgroundColor = ABRAppConfig.tintColor
            confirmPhoneBtn.layer.cornerRadius = 4
            confirmPhoneBtn.setTitle(ABRAppConfig.buttonsTitles.loginSendCodeToPhoneButtonTitle , for: .normal)
            confirmPhoneBtn.tintColor = UIColor.white
            confirmPhoneBtn.titleLabel?.font = ABRAppConfig.font
        }
        confirmPhoneBtn.addTarget(self, action: #selector(sendCodeAction), for: .touchUpInside)
        innerScrollView.addSubview(confirmPhoneBtn)

    
        
        if ABRAppConfig.mainButton != nil {
            confirmCodeBtn = ABRAppConfig.mainButton
            confirmCodeBtn.frame = CGRect(x: loginView.bounds.size.width + 30, y: loginView.bounds.size.height - 60 , width: loginView.bounds.size.width - 60 , height: 34)
        } else {
            confirmCodeBtn = UIButton(type: .system)
            confirmCodeBtn.frame = CGRect(x: loginView.bounds.size.width + 30, y: loginView.bounds.size.height - 60 , width: loginView.bounds.size.width - 60 , height: 34)
            confirmCodeBtn.backgroundColor = ABRAppConfig.tintColor
            confirmCodeBtn.layer.cornerRadius = 4
            confirmCodeBtn.setTitle(ABRAppConfig.buttonsTitles.loginConfirmCodeButtonTitle , for: .normal)
            confirmCodeBtn.tintColor = UIColor.white
            confirmCodeBtn.titleLabel?.font = ABRAppConfig.font
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
        
        
        backBtn = UIButton(type: .system)
        backBtn.frame = CGRect(x: loginView.bounds.width, y: 4, width: 30, height: 30)
        let img = UIImage(named: "AbringKit.bundle/images/back", in: Bundle.init(for: ABRApp.self), compatibleWith: nil) ?? UIImage()
        img.withRenderingMode(.alwaysTemplate)
        backBtn.setImage(img, for: .normal)
        backBtn.tintColor = ABRAppConfig.tintColor
        backBtn.addTarget(self, action: #selector(backToInputPhone), for: .touchUpInside)
        innerScrollView.addSubview(backBtn)
        
    }
    
    private func setupLabels() {
        inputPhoneLabel = UILabel(frame: CGRect(x: 10, y: 10, width: loginView.bounds.size.width - 20 , height: 80))
        inputPhoneLabel.text = ABRAppConfig.texts.inputPhoneText
        innerScrollView.addSubview(inputPhoneLabel)
        
        inputCodeLabel = UILabel(frame: CGRect(x: loginView.bounds.size.width + 10, y: 10, width: loginView.bounds.size.width - 20 , height: 80))
        inputCodeLabel.text = ABRAppConfig.texts.inputCodeText
        innerScrollView.addSubview(inputCodeLabel)
        
        for label in [inputCodeLabel , inputPhoneLabel] {
            if ABRAppConfig.font != nil {
                label?.font = UIFont(name: ABRAppConfig.font!.fontName, size: ABRAppConfig.font!.pointSize - 2)
            }
            
            label?.numberOfLines = 3
            label?.textColor = ABRAppConfig.labelsColor
            label?.textAlignment = .center
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
    
    
    private func refreshLayout() {
        innerScrollView.frame = loginView.bounds
        innerScrollView.contentSize = CGSize(width: loginView.bounds.size.width * 2 , height: loginView.bounds.size.height)
        
        inputPhoneLabel.frame = CGRect(x: inset, y: 10, width: loginView.bounds.size.width - (inset * 2) , height: 80)
        inputCodeLabel.frame = CGRect(x: loginView.bounds.size.width + inset, y: 10, width: loginView.bounds.size.width - inset * 2 , height: 80)
        
        confirmPhoneBtn.frame = CGRect(x: inset + 20, y: loginView.bounds.size.height - 60 , width: loginView.bounds.size.width - (inset * 2 + 40) , height: 34)
        confirmCodeBtn.frame = CGRect(x: loginView.bounds.size.width + inset + 20, y: loginView.bounds.size.height - 60 , width: loginView.bounds.size.width - (inset * 2 + 40) , height: 34)
        backBtn.frame = CGRect(x: loginView.bounds.width, y: 4, width: 30, height: 30)
        
        phoneTf.frame = CGRect(x: inset + 20, y: loginView.bounds.size.height / 2 - 25, width: loginView.bounds.size.width - (inset * 2 + 40), height: 30)
        codeTf.frame = CGRect(x: loginView.bounds.size.width + inset + 20, y: loginView.bounds.size.height / 2 - 25 , width: loginView.bounds.size.width - (inset * 2 + 40) , height: 30)
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
            ABRPlayer.requestRegisterCode(phoneNumber: phoneTf.text!, completion: { (success, errorType) in
                activity.stopAnimating()
                activity.removeFromSuperview()
                self.confirmPhoneBtn.setTitle(ABRAppConfig.buttonsTitles.loginSendCodeToPhoneButtonTitle, for: .normal)
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
            ABRPlayer.verifyRegisterCode(phoneNumber: phoneTf.text!, code: codeTf.text!, completion: { (success, player , errorType) in
                activity.stopAnimating()
                activity.removeFromSuperview()
                self.confirmCodeBtn.setTitle(ABRAppConfig.buttonsTitles.loginConfirmCodeButtonTitle, for: .normal)
                self.confirmCodeBtn.isEnabled = true
                if success {
                    self.view.endEditing(true)
                    if self.isFullScreen {
                        self.delegate?.userDidLogin(player!)
                    } else {
                        self.dismissAnimation {
                            self.dismiss(animated: false, completion: nil)
                            self.delegate?.userDidLogin(player!)
                        }
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
        self.delegate?.userDismissScreen!()
        dismissAnimation {
            self.dismiss(animated: false, completion: nil)
            
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


