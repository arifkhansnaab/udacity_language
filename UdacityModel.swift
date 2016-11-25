//
//  UdacityModel.swift
//  language
//
//  Created by Arif Khan on 11/24/16.
//  Copyright © 2016 Snnab. All rights reserved.
//


import Foundation

class UdacityModel {
    
    static let sheredInstance = UdacityModel()
    
    //logging in to udacity
    
    func requestForPOSTSession(_ jsonBody: [String:AnyObject], completionHandler:@escaping (_ success : Bool , _ errorType : String?)-> Void) -> Void {
        
        let urlString = UdacityConstants.URLConstants.BaseURL + UdacityConstants.Methods.Session
        let url = URL(string: urlString)!
        
        /* 3. Configure the request */
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(UdacityConstants.HTTPFields.ApplicationJSON, forHTTPHeaderField: UdacityConstants.HTTPFields.Accept)
        request.addValue(UdacityConstants.HTTPFields.ApplicationJSON, forHTTPHeaderField: UdacityConstants.HTTPFields.ContentType)
        
        do {
            request.httpBody = try! JSONSerialization.data(withJSONObject: jsonBody, options: .prettyPrinted)
        }
        
        /* 4. Make the request */
        SessionAndParseModel.sheredInstance.sessionAndParseTask(request, client: .udacity) { (result, error) -> Void in
            if error == nil {
                /* GUARD: Is the "account" key in parsedResult? */
                guard let accountStatus = result?[UdacityConstants.JSONKeys.Account] as? [String : AnyObject] else {
                    completionHandler(false, "No match on email/password combination.")
                    return
                }
                guard let sessionKey = accountStatus[UdacityConstants.JSONKeys.Key] as? String else {
                    completionHandler(false, "No match on email/password combination.")
                    return
                }
                UdacityConstants.UserData.UserSessionKey = sessionKey
                completionHandler(true, nil)
                
            }else if error != nil{
                if error?.code == 403 {
                    completionHandler(false, "No match on email/password combination.")
                    
                }else{
                    completionHandler(false, "Network Error")
                }
            }
        }
        
        return
    }
    
    func requestForDELETESession(_ completionHandler :@escaping ( _ success : Bool , _ errorString :String?)-> Void )-> Void {
        
        let NSURLString = UdacityConstants.URLConstants.BaseURL + UdacityConstants.Methods.Session
        let request = NSMutableURLRequest(url: URL(string: NSURLString)!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        SessionAndParseModel.sheredInstance.sessionAndParseTask(request, client: .udacity) { (result, error) -> Void in
            //here if there are no errores we will get back the parsed data after serialization ready for inspection
            // 1. if the errror responder was empty
            if error == nil {
                if let sessionDictionary = result?[UdacityConstants.JSONKeys.Session] as? [String:AnyObject] {
                    if let _ = sessionDictionary[UdacityConstants.JSONKeys.SessionID] as? String {
                        completionHandler(true, nil)
                    } else {
                        completionHandler(false, "Logout fail: reading sessionId from Udacity")
                    }
                } else {
                    completionHandler(false, "Logout fail: reading response from Udacity")
                }
            } else if let error = error {
                completionHandler(false, error.description)
            }
        }
        return
    }
    
    func requestForGETUserData(_ completionHandler: @escaping (_ userInfo: [String:String]?,  _ errorString: String?) -> Void) -> Void {
        
        var userInfo = [String:String]()
        let request = NSMutableURLRequest(url: URL(string: UdacityConstants.URLConstants.BaseURL + UdacityConstants.Methods.UserData + UdacityConstants.UserData.UserSessionKey)!)
        request.httpMethod = "GET"
        
        SessionAndParseModel.sheredInstance.sessionAndParseTask(request, client: .udacity) { (result, error) in
            if error == nil {
                if let userDictionary = result?[UdacityConstants.JSONKeys.UserDictionary] as? [String:AnyObject] {
                    // we don't need anything other than full name so create new shorter dictionary and send that instead
                    if let lastName = userDictionary[UdacityConstants.JSONKeys.LastName] as? String {
                        userInfo[UdacityConstants.JSONKeys.LastName] = lastName
                    }
                    if let firstName = userDictionary[UdacityConstants.JSONKeys.FirstName] as? String {
                        userInfo[UdacityConstants.JSONKeys.FirstName] = firstName
                    }
                    if let uniqueKey = userDictionary[UdacityConstants.JSONKeys.Key] as? String {
                        userInfo[UdacityConstants.JSONKeys.Key] = uniqueKey
                    }
                    
                    completionHandler(userInfo, nil)
                } else {
                    completionHandler(nil, "User data fail: reading response from Udacity")
                }
            } else if let error = error {
                completionHandler(nil, error.description)
            }
        }
        return
    }
    
    
    
}
