//
//  Utility.swift
//  language
//
//  Created by Arif Khan on 11/12/16.
//  Copyright © 2016 Snnab. All rights reserved.
//

import Foundation

// MARK: Enum to indicate client
enum ClientSelection {
    case udacity
    case parse
}

struct authenticationStatus {
    static let custom = "Custom"
    static let facebook = "Facebook"
    static let google = "Google"
}

struct wordLearningStatus {
    static let mastered = "Mastered"
    static let shaky = "Shaky"
    static let unknown = "Unknown"
}

struct generalConstants {
    static let loginId = "loginId"
    static let cellBorderWidth = 2.0
    static let cellHeight = 120
    static let cellWidth = 120
}

class  UdacityConstants {
    
    struct URLConstants {
        static let BaseURL: String = "https://www.udacity.com/api/"
        static let SignUpURL: String = "https://www.udacity.com/account/auth#!/signin"
    }
    
    struct Methods {
        static let Session = "session"
        static let UserData = "users/"
    }
    struct UserData {
        static var UserSessionKey = ""
    }
    
    struct HTTPFields {
        static let XSRFToken = "X-XSRF-TOKEN"
        static let ApplicationJSON = "application/json"
        static let Accept = "Accept"
        static let ContentType = "Content-Type"
    }
    
    struct JSONKeys {
        /* POSTing (Creating) a Session */
        static let Account = "account" //outer dictionary
        static let Registered = "registered"
        static let Key = "key" //also used in GET
        static let Udacity = "udacity" //httpbody outer
        static let Username = "username"
        static let Password = "password"
        static let facebook_mobile = "facebook_mobile"
        static let access_token = "access_token"
        
        
        static let Session = "session" //outer dict; also used in DELETE
        static let SessionID = "id" //also used in DELETE
        static let Expiration = "expiration" //also used in DELETE
        
        /* GET public user data */
        static let UserDictionary = "user"
        static let LastName = "last_name"
        static let FirstName = "first_name"
    }
}
