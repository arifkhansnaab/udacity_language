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
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 0.5
        
        let memeTextAttributes = [
            //NSStrokeColorAttributeName: UIColor.black,
            //NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 25)!,
            //NSStrokeWidthAttributeName: -3.0,
            ] as [String : Any]
        
        self.defaultTextAttributes = memeTextAttributes
        self.textAlignment = NSTextAlignment.center
        //self.text = defaultText
    }
}



