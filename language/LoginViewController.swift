//
//  ViewController.swift
//  language
//
//  Created by Arif Khan on 11/5/16.
//  Copyright © 2016 Snnab. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var myTextFields = [UITextField]()
    var myButtons = [UIButton]()
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var faceBookButton: UIButton!
    
    @IBOutlet weak var googleButton: UIButton!
    
    
    @IBAction func loginButton(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setColorsAndBorders()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setColorsAndBorders() {
        myTextFields = [userTextField,passwordTextField]
        myButtons = [loginButton, faceBookButton, googleButton]
        
        for item in myTextFields {
            item.setPreferences()
        }
            
            for item in myButtons {
            item.setPreferences()
            }
    }
}

