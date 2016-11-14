//
//  RegisterUserViewController.swift
//  language
//
//  Created by Arif Khan on 11/13/16.
//  Copyright © 2016 Snnab. All rights reserved.
//

import Foundation
import UIKit

class RegisterUserViewController: UIViewController {
    
    var myTextFields = [UITextField]()
    var myButtons = [UIButton]()
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var displayNameTextBox: UITextField!
    @IBOutlet weak var lastNameTextBox: UITextField!
    @IBOutlet weak var firstNameTextBox: UITextField!
    @IBOutlet weak var loginTextBox: UITextField!
    
    @IBOutlet weak var reenterPasswordTextBox: UITextField!
    @IBOutlet weak var passwordTextBox: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setColorsAndBorders()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerUser(_ sender: Any) {
    }
    
    func setColorsAndBorders() {
        myTextFields = [displayNameTextBox,lastNameTextBox,firstNameTextBox,loginTextBox,passwordTextBox,reenterPasswordTextBox]
        myButtons = [registerButton]
        
        for item in myTextFields {
            item.setPreferences()
        }
        
        for item in myButtons {
            item.setPreferences()
        }
    }
}
