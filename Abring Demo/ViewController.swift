//
//  ViewController.swift
//  Abring Demo
//
//  Created by Hosein on 5/7/1396 AP.
//  Copyright © 1396 AP AsemanLTD. All rights reserved.
//

import UIKit

class ViewController: UIViewController , AbLoginDelegate {

    @IBOutlet weak var alertLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        alertLabel.alpha = 0
        
    }

    @IBAction func buttonPressed() {
        presentLogin(style: .LightBlurBackground, delegate: self)
    }
    
    func userDidLogin(_ player: ABPlayer) {
        showAlert("کاربر با کد \(player.id) وارد شد")
    }
    
    func userDismissScreen() {
        showAlert("کاربر صفحه را بست")
    }

    
    
    // flash alret
    func showAlert(_ message : String) {
        alertLabel.text = message
        alertLabel.alpha = 1
        
        UIView.animate(withDuration: 2, delay: 0.3, options: .curveLinear , animations: { 
            self.alertLabel.alpha = 0
        }, completion: nil)
    }

}

