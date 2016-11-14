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
    @IBAction func registerMe(_ sender: Any) {
        let oViewController = storyboard!.instantiateViewController(withIdentifier: "RegisterUserViewController") as! RegisterUserViewController
        
        navigationController!.pushViewController(oViewController, animated: true)
    }
    @IBOutlet weak var passwordTextField: UITextField!
    
    var myTextFields = [UITextField]()
    var myButtons = [UIButton]()
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var faceBookButton: UIButton!
    
    @IBOutlet weak var registerMeButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    
    
    @IBAction func loginButton(_ sender: Any) {
        let oViewController = storyboard!.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        
        navigationController!.pushViewController(oViewController, animated: true)
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
        myButtons = [loginButton, faceBookButton, googleButton, registerMeButton]
        
        for item in myTextFields {
            item.setPreferences()
        }
            
        for item in myButtons {
            item.setPreferences()
        }
    }
}

