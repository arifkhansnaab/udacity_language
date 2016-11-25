//
//  ViewController.swift
//  language
//
//  Created by Arif Khan on 11/5/16.
//  Copyright © 2016 Snnab. All rights reserved.
//

import UIKit
import CoreData


class LoginViewController1: UIViewController, FBSDKLoginButtonDelegate {

    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let loginButton: FBSDKLoginButton = {
       let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()
    
    
    @IBOutlet weak var logInText: UILabel!
    @IBOutlet weak var fbLoginView: FBSDKLoginButton!
    
    @IBOutlet weak var userTextField: UITextField!
    @IBAction func registerMe(_ sender: Any) {
        let oViewController = storyboard!.instantiateViewController(withIdentifier: "RegisterUserViewController") as! RegisterUserViewController
        
        navigationController!.pushViewController(oViewController, animated: true)
    }
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func loginFacebook(_ sender: Any) {
        
    }
    
    var myTextFields = [UITextField]()
    var myButtons = [UIButton]()
    
    @IBOutlet weak var loginButton1: UIButton!
    
    @IBOutlet weak var faceBookButton: UIButton!
    
    @IBOutlet weak var registerMeButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    
    
    @IBAction func loginButton(_ sender: Any) {
        let oUser = searchUser(login: userTextField.text!,password: passwordTextField.text!)
        
        if ( oUser == nil ) {
            let alert = UIAlertController(title: "Alert", message: "User login failure - invalid login / password", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
                //do nothing
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        } else {
            
            UserManager.AddLogedInUser(loginId: userTextField.text!)
            
            let oViewController = storyboard!.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
            navigationController!.pushViewController(oViewController, animated: true)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.loginButton.delegate = self
        
        
       // let loginManager = FBSDKLoginManager()
       // FBSDKLoginManager.logOut(loginManager)()
        
        
        if (FBSDKAccessToken.current() != nil)
        {
            let loginManager = FBSDKLoginManager()
            FBSDKLoginManager.logOut(loginManager)()
        }
        else
        {
            fbLoginView.delegate = self
            fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]
            FBSDKProfile.enableUpdates(onAccessTokenChange: true)
            
        }
        
      
        
        setColorsAndBorders()

    }
    
   /* func fetchProfile1() {
        print("fetch profile")
        
        
        let parameters = ["fields": "email, first_name, last_name,  picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection, result, error) in
            
            guard let resultNew = result as? [String:Any]
            
            let email = resultNew["email"]  as! String
        }
        
      /*  let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection,
                                                                                                 result, error) -> Void in
            
            if error != nil {
                print(error)
                return
            }
            
            
            guard let resultNew = result as? [String:Any]
            
             let email = resultNew["email"] as! String
                print(email)
            
            
            if let picture = result["picture"] as? NSDictionary, let data = picture["data"] as? NSDictionary, let url = data["url"] as? String {
                print(url)
            }
        }*/
    }*/
    
    func fetchProfile(){
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : "email, name, id, gender"])
            .start(completionHandler:  { (connection, result, error) in
                guard let result = result as? NSDictionary, let email = result["email"] as? String,
                    let user_name = result["name"] as? String,
                    let user_gender = result["gender"] as? String,
                    let user_id_fb = result["id"]  as? String else {
                        return
                }
            })
        
    }
    
    func returnUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    print(result)
                    //result.valueForKey("email") as! String
                    //result.valueForKey("id") as! String
                    //result.valueForKey("name") as! String
                    //result.valueForKey("first_name") as! String
                    //result.valueForKey("last_name") as! String
                }
            })
        } else {
            let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
            fbLoginManager.logOut()
        }
    }

    
    
   /* func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("completed login")
        fetchProfile()
        returnUserData()
    }*/
    

    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("User Logged In")
        
        //print (result)
        if ((error) != nil)
        {
            print (error.localizedDescription)
           self.presentError(error.localizedDescription)
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
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print ("log out")
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logOut()
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        print ("will login")
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        fbLoginManager.logOut()
                    }
                }
            }
        }
        
        return true
    }
    
    var dict : [String : AnyObject]!
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    print(self.dict)
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    func setColorsAndBorders() {
        myTextFields = [userTextField,passwordTextField]
        myButtons = [faceBookButton, googleButton, registerMeButton]
        
        for item in myTextFields {
            item.setPreferences()
        }
            
        for item in myButtons {
            item.setPreferences()
        }
    }
}

