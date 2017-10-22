//
//  ABFullScreenLoginViewController.swift
//  Abring Demo
//
//  Created by Hosein on 5/8/1396 AP.
//  Copyright © 1396 AP AsemanLTD. All rights reserved.
//

import UIKit


class ABRFullScreenLoginViewController: UIViewController , ABRLoginDelegate {
    
    var backgroundColor : UIColor? 
    var backgroundImage : UIImage?
    var identifier : String?
    var storyBoard : String?
    var login : ABRLoginViewController!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        login = ABRLoginViewController()
        login.isFullScreen = true
        addChildViewController(login)
        login.view.frame = view.frame
        login.view.backgroundColor = backgroundColor
        login.delegate = self
        if backgroundImage != nil {
            login.view.insertSubview(createImageView(), at: 0)
        }
        view.addSubview(login.view)
        login.didMove(toParentViewController: self)
        
    }
    
    func createImageView() -> UIImageView {
        let bgImageView = UIImageView(frame: view.bounds)
        bgImageView.image = backgroundImage
        bgImageView.contentMode = .scaleAspectFill
        return bgImageView
    }
    
    

    func userDidLogin(_ player: ABRPlayer) {
        let storyboard = UIStoryboard(name: storyBoard!, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier!)
        present(vc, animated: true) { 
            self.login.willMove(toParentViewController: nil)
            self.login.view.removeFromSuperview()
            self.login.removeFromParentViewController()
        }

    }
}
