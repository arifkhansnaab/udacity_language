//
//  UITextFieldExtension.swift
//  language
//
//  Created by Arif Khan on 11/12/16.
//  Copyright © 2016 Snnab. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func setPreferences() {
        self.layer.cornerRadius = 3
        
       //self.txtview.frame.size.height = 600
        
        self.frame.size.height = 50
        
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.borderColor = UIColor(red: 0.25098040700000002, green: 0.0, blue: 0.50196081400000003, alpha: 1.0).cgColor
        //self.layer.borderColor = UIColor.mocha
        self.layer.borderWidth = 0
        
        let memeTextAttributes = [
            //NSStrokeColorAttributeName: UIColor.black,
            //NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "Cochin", size: 25)!,
            //NSStrokeWidthAttributeName: -3.0,
            ] as [String : Any]
        
        self.defaultTextAttributes = memeTextAttributes
        self.textAlignment = NSTextAlignment.center
        //self.text = defaultText
    }
}

