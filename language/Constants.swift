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
    static let access_token = "access_token"
    static let facebook_mobile = "facebook_mobile"
}
