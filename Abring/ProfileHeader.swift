//
//  ProfileHeaderCell.swift
//  Abring Demo
//
//  Created by Hosein on 5/9/1396 AP.
//  Copyright © 1396 AP AsemanLTD. All rights reserved.
//

import UIKit

class ProfileHeader: UITableViewCell {
    
    // There is a default .xib file attached to this class,
    // If you want a custom design and layout you should make your .xib file and then attach its views to these properties:
    
    // Player profile image view
    @IBOutlet weak var avatarImageView: UIImageView!
    
    // Player logout button, do not implement its action, it will be added automatically
    @IBOutlet weak var logoutButton: UIButton!
    
    // Player edit profile view controller , do not implement its action, it will be added automatically
//    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var editButton: ABSwitchableButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    // Height constraint for container view, it's just for stretch effect. You can ignore this of you want
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    
    // Activity view that animates when avatarImageView is loading the profile image
    @IBOutlet weak var loadActivity: UIActivityIndicatorView!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        logoutButton.titleLabel?.font = ABAppConfig.font
        editButton.titleLabel?.font = ABAppConfig.font
        logoutButton.setTitleColor(UIColor.white, for: .normal)
        editButton.setTitleColor(UIColor.white, for: .normal)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
