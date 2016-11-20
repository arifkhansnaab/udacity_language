//
//  UserManager.swift
//  language
//
//  Created by Arif Khan on 11/19/16.
//  Copyright © 2016 Snnab. All rights reserved.
//

import Foundation

class UserManager {
    
    static func AddLogedInUser(loginId: String) {
        //Store user login
        UserDefaults.standard.set(loginId, forKey: generalConstants.loginId)
    }
    
    static func GetLogedInUser() -> String? {
        let prefs = UserDefaults.standard
        
        if let loginId = prefs.string(forKey: generalConstants.loginId){
            return loginId
        }
        return nil
    }
}
