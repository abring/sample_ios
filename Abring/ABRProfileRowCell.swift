//
//  ProfileRowCell.swift
//  Abring Demo
//
//  Created by Hosein Abbaspour on 5/9/1396 AP.
//  Copyright © 1396 AP AsemanLTD. All rights reserved.
//

import UIKit


/**
 Table view cell class for Abring built-in profile tableViewController.
 
 There is a default .xib file attached to this class. If you want a custom design and layout you should make your .xib file and name it 'ABRProfileRow' and change its File Owner to this class and then attach your views (you need two labels at least) to this class properties.
 */

class ABRProfileRowCell: UITableViewCell {


    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var valueTextField: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        titleLabel.font = ABRAppConfig.font
        valueTextField.font = ABRAppConfig.font
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
