//
//  ABNewVersionViewController.swift
//  Abring Demo
//
//  Created by Hosein on 6/27/1396 AP.
//  Copyright © 1396 AP AsemanLTD. All rights reserved.
//

import UIKit

class ABNewVersionViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var laterButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    
    
    var app : ABApp?
    var isForce = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("fdsf")
        setup()
        setAppIcon()
        
        let msg = "نسخه‌ی " + (app?.currentVersion?.versionString ?? "-") + " برای دریافت موجود است"

        
        if isForce {
            laterButton.isHidden = true
            messageLabel.text = msg + "\n" + "برای ادامه‌ی استفاده از برنامه دانلود الزامیست"
        } else {
            if let ver = app?.currentVersion?.versionString {
                UserDefaults.standard.set(true, forKey: ver)
                UserDefaults.standard.synchronize()
            }
            messageLabel.text = msg
        }
        
        
    }
    
  
    
    func setup() {
        downloadButton.backgroundColor = ABAppConfig.tintColor
        laterButton.setTitleColor(ABAppConfig.tintColor, for: .normal)
        downloadButton.titleLabel?.font = ABAppConfig.font
        downloadButton.setTitle(ABAppConfig.buttonsTitles.updateDownloadButtonTitle, for: .normal)
        laterButton.titleLabel?.font = ABAppConfig.font
        laterButton.setTitle(ABAppConfig.buttonsTitles.updateLaterButtonTitle, for: .normal)
        messageLabel.font = ABAppConfig.font
        
    }
    
    func setAppIcon() {
        guard let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String:Any],
            let primaryIconsDictionary = iconsDictionary["CFBundlePrimaryIcon"] as? [String:Any],
            let iconFiles = primaryIconsDictionary["CFBundleIconFiles"] as? [String],
            let lastIcon = iconFiles.last else { return}
        logoImageView.image = UIImage(named: lastIcon)
    }
    
    @IBAction func download() {
        let url = URL(string: app?.versionUrl ?? "")
        assert(url != nil, "Abring : the url object in app date -> update variable is not valid")
        UIApplication.shared.open(url! , options: [:], completionHandler: nil)
    }
    
    @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    

}
