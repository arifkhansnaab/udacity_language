//
//  RegisterUserViewController.swift
//  language
//
//  Created by Arif Khan on 11/13/16.
//  Copyright © 2016 Snnab. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class RegisterUserViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var myTextFields = [UITextField]()
    var myButtons = [UIButton]()
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
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
        
        //Set the text field delegate, so that return key bring down the keyboard
        displayNameTextBox.delegate = self
        lastNameTextBox.delegate = self
        firstNameTextBox.delegate = self
        loginTextBox.delegate = self
        reenterPasswordTextBox.delegate = self
        passwordTextBox.delegate = self
    }
    
    override func  viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    
    @IBAction func loginTextChanged(_ sender: Any) {
        let arr = UtilityFunction.getFirstLastFromEmail(email: loginTextBox.text!)
        firstNameTextBox.text = arr[0]
        lastNameTextBox.text = arr[1]
        displayNameTextBox.text = arr[0].description.appending(" ")
        displayNameTextBox.text = displayNameTextBox.text?.appending(arr[1].description)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerUser(_ sender: Any) {
        
        view.frame.origin.y = 0
        
        let context = CoreDataStackManager.sharedInstance().managedObjectContext!
        
        if ( passwordTextBox.text?.characters.count == 0 ) {
            errorLabel.text = "password cannot be empty"
            return
        }
        
        if ( passwordTextBox.text != reenterPasswordTextBox.text) {
            errorLabel.text = "password and re-enter password do not match"
            return
        }
        
        if ( UtilityFunction.isValidEmail(testStr: loginTextBox.text!) == false) {
            errorLabel.text = "invalid email - login id must be a valid email"
            return
        }
        
        _ = User(login: loginTextBox.text!, pass: passwordTextBox.text!, first: firstNameTextBox.text!, last: lastNameTextBox.text!, display: displayNameTextBox.text!, mode: authenticationStatus.custom, context: context)
        
        do {
            try context.save()
            
            let alert = UIAlertController(title: "Alert", message: "User registered successfully", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
                
                let oViewController = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! FBLoginViewController
                self.navigationController!.pushViewController(oViewController, animated: true)
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        } catch let error as NSError {
            print (error)
        }
        
    }
    
    func registerUser() {
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
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterUserViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterUserViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if (UIApplication.shared.statusBarOrientation.isPortrait ) {
            if (displayNameTextBox.isFirstResponder ) {
                view.frame.origin.y = -getKeyboardHeight(notification: notification)
            } else if (firstNameTextBox.isFirstResponder || lastNameTextBox.isFirstResponder) {
                view.frame.origin.y = -getKeyboardHeight(notification: notification)+(2*firstNameTextBox.frame.height)
            }
            else {
                view.frame.origin.y = 0
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if (
            loginTextBox.isFirstResponder || passwordTextBox.isFirstResponder || reenterPasswordTextBox.isFirstResponder ||
            firstNameTextBox.isFirstResponder || displayNameTextBox.isFirstResponder || lastNameTextBox.isFirstResponder){
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
