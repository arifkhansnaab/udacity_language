//
//  LogInViewController.swift
//  On_The_Map_EM
//
//  Created by Lauren Efron on 04/01/2016.
//  Copyright © 2016 Eitan_Magen. All rights reserved.
//Working version

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
class LogInViewController: UIViewController ,FBSDKLoginButtonDelegate {
    
    var appDelegate : AppDelegate!
    static let sheredInstance = LogInViewController()
    
    var session: URLSession!
    
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logInText: UILabel!
    @IBOutlet weak var facebookauth: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // @IBAction func FBbuttonView(sender: AnyObject) {
    //  }
    @IBOutlet weak var fbLoginView: FBSDKLoginButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if (FBSDKAccessToken.current() != nil)
        {
            returnUserData()
            let loginManager = FBSDKLoginManager()
            FBSDKLoginManager.logOut(loginManager)()
        }
        else
        {
            fbLoginView.delegate = self
            fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]
            FBSDKProfile.enableUpdates(onAccessTokenChange: true)
            
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("User Logged In")
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
            if result.grantedPermissions.contains("email")
            {
                
                // Do work
                logInText.text = "LogIn to Udacity With FB"
                var userInfo = [String:String]()
                userInfo[UdacityConstants.JSONKeys.access_token] = FBSDKAccessToken.current().tokenString
                let jsonBody = [UdacityConstants.JSONKeys.facebook_mobile: userInfo] //build the json body a array of dictianary
                
                print(jsonBody)
                
                UdacityModel.sheredInstance.requestForPOSTSession(jsonBody as [String : AnyObject] , completionHandler: {(success, errorType) -> Void in
                    if success {
                        DispatchQueue.main.async(execute: {
                            self.showActivityIndicator()//flips the condition of the indictor , stops the animation once logged in
                            self.performSegue(withIdentifier: "NavigationSague", sender: self)
                        })
                    } else if errorType != nil {
                        DispatchQueue.main.async(execute: {
                            self.showActivityIndicator()//flips the condition of the indictor , stops the animation once logged in
                            self.presentError(errorType!)
                        })
                        
                    }
                    
                })
                
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
        if let requestUrl = URL(string: "https://www.udacity.com/account/auth#!/signin") {
            UIApplication.shared.openURL(requestUrl)
        } else {
            presentError("Error opening url: " + "https://www.udacity.com/account/auth#!/signin")
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        emailTextField.text = ""
        passwordTextField.text = ""
        activityIndicator.isHidden = true
    }
    
    @IBAction func logInButton(_ sender: UIButton) {
        logInText.text = "LogIn to Udacity"
        var userInfo = [String:String]()
        userInfo[UdacityConstants.JSONKeys.Username] = emailTextField.text
        userInfo[UdacityConstants.JSONKeys.Password] = passwordTextField.text
        let jsonBody = [UdacityConstants.JSONKeys.Udacity: userInfo] //build the json body a array of dictianary
        
        if emailTextField.text!.isEmpty {
            logInText.text = "Username Empty."
            return
        } else if passwordTextField.text!.isEmpty {
            logInText.text = "Password Empty."
            return
        }
        showActivityIndicator()//starts the animation of the login indicator until we loged in!
        
        UdacityModel.sheredInstance.requestForPOSTSession(jsonBody as [String : AnyObject] , completionHandler: {(success, errorType) -> Void in
            if success {
                DispatchQueue.main.async(execute: {
                    self.passwordTextField.text = ""
                    self.showActivityIndicator()//flips the condition of the indictor , stops the animation once logged in
                    self.performSegue(withIdentifier: "NavigationSague", sender: self)
                })
            } else if errorType != nil {
                DispatchQueue.main.async(execute: {
                    self.showActivityIndicator()//flips the condition of the indictor , stops the animation once logged in
                    self.presentError(errorType!)
                })
                
            }
            
        })
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
    
    
}

