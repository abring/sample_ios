//
//  MyTableViewController.swift
//  Abring Demo
//
//  Created by Hosein on 8/1/1396 AP.
//  Copyright © 1396 AP AsemanLTD. All rights reserved.
//

import UIKit
import Abring

class MyTableViewController: ABRProfileViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        header?.avatarImageView.layer.borderColor = UIColor.white.cgColor
        header?.avatarImageView.layer.borderWidth = 2
        
    }
    
    
    override func signoutAction(_ sender: UIButton?) {
        super.signoutAction(sender)
        print("sub")
    }

    override func userWantsToLogin() {
        tabBarController?.selectedIndex = 0
    }
}
