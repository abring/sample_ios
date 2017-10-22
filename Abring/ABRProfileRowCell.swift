//
//  ProfileRowCell.swift
//  Abring Demo
//
//  Created by Hosein on 5/9/1396 AP.
//  Copyright © 1396 AP AsemanLTD. All rights reserved.
//

import UIKit

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
