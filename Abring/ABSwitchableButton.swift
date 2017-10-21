//
//  ABSwitchableButton.swift
//  Abring Demo
//
//  Created by Hosein on 5/15/1396 AP.
//  Copyright © 1396 AP AsemanLTD. All rights reserved.
//

import UIKit


public class ABSwitchableButton: UIButton {
    
    public var isEditting = false {
        didSet {
            if isEditting {
                self.addTarget(self, action: #selector(btnTouched(_:)), for: .touchUpInside)
            } else {
                self.removeTarget(self, action: #selector(btnTouched(_:)), for: .touchUpInside)
            }
        }
    }
    
    @IBInspectable var defaultTitle : String?
    @IBInspectable var editingTitle : String?
    
    @IBInspectable var defaultImage : UIImage?
    @IBInspectable var editingImage : UIImage?
    
    
    public override func setTitle(_ title: String?, for state: UIControlState) {
        super.setTitle(title, for: state)
        
    }
    
    
    
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override public func draw(_ rect: CGRect) {
//        print("redraw")
//        // Drawing code
//        if isEditting {
//            if editingImage != nil {
//                self.setTitle(nil, for: .normal)
//                self.setImage(editingImage, for: .normal)
//            } else {
//                self.setTitle(editingTitle, for: .normal)
//                self.setImage(nil, for: .normal)
//            }
//            self.titleLabel?.text = editingTitle
//        } else {
//            self.setTitle(defaultTitle, for: .normal)
//        }
        titleLabel?.text = defaultTitle
    }
    
    func btnTouched(_ sender : UIButton!) {
        print(isSelected)
    }
    

    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        print(touch.location(in: self))
        
        return super.beginTracking(touch, with: event)
    }
 

}
