//
//  Error.swift
//  language
//
//  Created by Arif Khan on 11/24/16.
//  Copyright © 2016 Snnab. All rights reserved.
//


import UIKit

extension UIViewController{
    func presentError(_ alertString: String){
        let ac = UIAlertController(title: "Error", message: alertString, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(ac, animated: true, completion: nil)
        
        
    }
}

