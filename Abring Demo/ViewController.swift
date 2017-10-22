//
//  ViewController.swift
//  Abring Demo
//
//  Created by Hosein on 5/7/1396 AP.
//  Copyright © 1396 AP AsemanLTD. All rights reserved.
//

import UIKit
import Abring

class ViewController: UIViewController , ABRLoginDelegate {

    @IBOutlet weak var alertLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertLabel.alpha = 0
        loginIfNeeded(storyBoard: "Main", rootIdentifier: "root")

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        ABVersion.checkForUpdate()
        
        print(ABRPlayer.current()?.name)

    }

    @IBAction func buttonPressed() {
        presentLogin(style: .darken , delegate: self)

    }
    
    
    
    //MARK: Login delegate methods :
    // userDismissScreen is an optional method
    
    func userDidLogin(_ player: ABRPlayer) {
        showAlert("کاربر با کد \(player.id) وارد شد")
    }
    
    func userDismissScreen() {
        showAlert("کاربر صفحه را بست")
    }

    
    
    // Flash Alert
    // After putting your number and requesting verifynig code,
    // if you give any respond other than 200 you'll see a flashing alert.
    
    func showAlert(_ message : String) {
        alertLabel.text = message
        alertLabel.alpha = 1
        
        UIView.animate(withDuration: 2, delay: 0.3, options: .curveLinear , animations: { 
            self.alertLabel.alpha = 0
        }, completion: nil)
    }

}

