//
//  ProfileHeaderCell.swift
//  Abring Demo
//
//  Created by Hosein Abbaspour on 5/9/1396 AP.
//  Copyright © 1396 AP AsemanLTD. All rights reserved.
//

import UIKit

/**
 Table view header class for Abring built-in profile tableViewController.
 
 There is a default .xib file attached to this class. If you want a custom design and layout you should make your .xib file and name it 'ABRProfileHeader' and change its File Owner to this class and then attach your views (you need imageView, title label and two buttons) to this class properties.
*/

public class ABRProfileHeader: UITableViewCell {
    
    /// Player profile image view
    @IBOutlet public weak var avatarImageView: UIImageView!
    
    /// Player logout button, do not implement its action, it will be added automatically.
    /// for this button if you need custom action like present an alert when user tapped signout button you need to create a subclass of ABRProfileViewController and override signoutAction.
    /// ## Note
    /// if you did this don't forget to implement `ABRPlayer.logout()` method.
    @IBOutlet public weak var signoutButton: UIButton!
    
    /// Player edit profile button, do not implement its action, it will be added automatically.
    /// for this button if you need custom action like present an alert when user tapped edit button you need to create a subclass of ABRProfileViewController and override editAction.
    /// ## Note
    /// if you did this don't forget to save user data with `ABRPlayer.set(_:)`.
//    @IBOutlet weak var editButton: UIButton!
    @IBOutlet public weak var editButton: ABRSwitchableButton!
    
    
    /// This label will be appear under imageView in Abring default UI.
    @IBOutlet public weak var headerTitleLabel: UILabel!
    
    /// Height constraint for container view, it's just for stretch effect. You can ignore this if you wish
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    
    /// Activity view that animates when avatarImageView is loading the profile image
    @IBOutlet public weak var loadActivity: UIActivityIndicatorView!
    
    /// Header container view
    @IBOutlet public weak var headerContainer: UIView!
    
    

    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        signoutButton.titleLabel?.font = ABRAppConfig.font
        editButton.titleLabel?.font = ABRAppConfig.font
        signoutButton.setTitleColor(UIColor.white, for: .normal)
        editButton.setTitleColor(UIColor.white, for: .normal)
        
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
