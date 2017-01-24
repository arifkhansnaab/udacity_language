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
    static let language_webapi_searchword_url = "https://language-150802.appspot.com/_ah/api/language/v1/words"
    static let language_webapi_publishword_url = "https://language-150802.appspot.com/_ah/api/language/v1/publishWord"
}

struct wordConstant {
    static let sourceWord = "sourceWord"
    static let translatedWord = "translatedWord"
    static let language = "language"
    static let publishedDate = "publishedDate"
    static let publishedBy = "publishedBy"
}

struct colorFontConstant {
    static let redValue : CGFloat = 0.25098040700000002
    static let greenValue : CGFloat = 0.0
    static let blueValue : CGFloat = 0.50196081400000003
    static let alphaValue : CGFloat = 1.0
    static let fontName = "Cochin"
    static let fontSize : CGFloat = 25
}
