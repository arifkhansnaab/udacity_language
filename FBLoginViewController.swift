//
//  FBLoginViewController.swift
//  language
//
//  Created by Arif Khan on 11/13/16.
//  Copyright © 2016 Snnab. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import CoreData

class FBLoginViewController: UIViewController ,FBSDKLoginButtonDelegate, UITextFieldDelegate {
    
    var appDelegate : AppDelegate!
    static let sheredInstance = FBLoginViewController()
    
    var session: URLSession!
    var myTextFields = [UITextField]()
    var myButtons = [UIButton]()
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginDisplayText: UILabel!
    @IBOutlet weak var facebookauth: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var fbLoginView: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the text field delegate, so that return key bring down the keyboard
        emailTextField.delegate = self
        passwordTextField.delegate = self
    
        // Do any additional setup after loading the view, typically from a nib.
        
        if (FBSDKAccessToken.current() != nil) {
            let loginManager = FBSDKLoginManager()
            FBSDKLoginManager.logOut(loginManager)()
        }
        else {
            fbLoginView.delegate = self
            fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]
            FBSDKProfile.enableUpdates(onAccessTokenChange: true)
        }
        setColorsAndBorders()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //Used during testing
        //emailTextField.text = "arifkhan2@hotmail.com"
        //passwordTextField.text = "p"
        
        if (FBSDKAccessToken.current() != nil) {
            returnUserData()
        }
        

        return super.viewDidAppear(animated)
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {

        if ((error) != nil)
        {
            self.presentError(error! as! String)
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email") {
                // Do work
                loginDisplayText.text = "Log in using FB"
                var userInfo = [String:String]()
                userInfo[generalConstants.access_token] = FBSDKAccessToken.current().tokenString
                let jsonBody = [generalConstants.facebook_mobile: userInfo] //build the json body a array of dictianary
                
                print(jsonBody)
            }
            
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func returnUserData() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                // let userName : NSString = result.value(forKey: "name") as! NSString
                // print("User Name is: \(userName)")
                //  let userEmail : NSString = result.value(forKey: "email") as! NSString
                // print("User Email is: \(userEmail)")
            }
        })
    }
    
    @IBAction func signUpButtonTouchUp(_ sender: UIButton) {
        let oViewController = storyboard!.instantiateViewController(withIdentifier: "RegisterUserViewController") as! RegisterUserViewController
        navigationController!.pushViewController(oViewController, animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        emailTextField.text = ""
        passwordTextField.text = ""
        activityIndicator.isHidden = true
        
        subscribeToKeyboardNotifications()
    }
    
    @IBAction func logInButton(_ sender: UIButton) {
        loginDisplayText.text = "LogIn"
        
        if emailTextField.text!.isEmpty {
            loginDisplayText.text = "Username Empty."
            return
        } else if passwordTextField.text!.isEmpty {
            loginDisplayText.text = "Password Empty."
            return
        }
        showActivityIndicator()//starts the animation of the login indicator until we loged in!
        
        
        let oUser = searchUser(login: emailTextField.text!,password: passwordTextField.text!)
        
        if ( oUser == nil ) {
            let alert = UIAlertController(title: "Alert", message: "User login failure - invalid login / password", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
                //do nothing
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        } else {
            
            UserManager.AddLogedInUser(loginId: emailTextField.text!)
            
            let oViewController = storyboard!.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
            navigationController!.pushViewController(oViewController, animated: true)
        }

        
        
        
          }
    
    func searchUser(login: String, password: String) -> User? {
        let context = CoreDataStackManager.sharedInstance().managedObjectContext!
        let user = NSFetchRequest<User>(entityName: "User")
        let searchQuery = NSPredicate(format: "loginId = %@ AND password = %@", argumentArray: [login, password])
        user.predicate = searchQuery
        
        if let result = try? context.fetch(user) {
            for object in result {
                return (object as User)
            }
        }
        return nil
    }

    
    func showActivityIndicator() {
        if activityIndicator.isHidden {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            activityIndicator.hidesWhenStopped = true
            
            
        }
    }
    
    override func presentError(_ alertString: String){
        /* Set transaction for when shake animation ceases */
        showActivityIndicator()
        CATransaction.begin()
        let ac = UIAlertController(title: "Error In Request", message: alertString, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        CATransaction.setCompletionBlock { () -> Void in
            self.present(ac, animated: true, completion: nil)
        }
        
        /* Configure shake animation */
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.3
        animation.autoreverses = true
        let fromPoint: CGPoint = CGPoint(x: self.view.center.x - 5, y: self.emailTextField.center.y)
        let fromValue: NSValue = NSValue(cgPoint: fromPoint)
        let toPoint: CGPoint = CGPoint(x: self.view.center.x + 5,y: self.emailTextField.center.y )
        let toValue: NSValue = NSValue(cgPoint: toPoint)
        animation.fromValue = fromValue
        animation.toValue = toValue
        
        /* Stop animating activity indicator */
        self.activityIndicator.stopAnimating()
        
        /* Animate view layer */
        //  self.view.layer.addAnimation(animation, forKey: "position")
        self.emailTextField.layer.add(animation, forKey: "position")
        
        /* Commit transaction */
        CATransaction.commit()
    } //Error handeler
    
    func setColorsAndBorders() {
        myTextFields = [emailTextField,passwordTextField]
        myButtons = [loginButton]
        
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
            if (emailTextField.isFirstResponder || passwordTextField.isFirstResponder) {
              
                view.frame.origin.y = 0
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if ( emailTextField.isFirstResponder || passwordTextField.isFirstResponder ){
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

