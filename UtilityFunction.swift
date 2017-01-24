//
//  UtilityFunction.swift
//  language
//
//  Created by Arif Khan on 11/19/16.
//  Copyright © 2016 Snnab. All rights reserved.
//

import Foundation

class UtilityFunction {
    static func getPercentKnownWords(totalWords: String, knownWords: String) -> String? {
        let tword = Double(totalWords)
        let knownWords = Double(knownWords)
        
        if ( Int(tword!) > 0 ) {
            let val = (knownWords!/tword!)*100
            return Int(round(val)).description
        }
        
        return 0.description
    }
    
    static func getConvertedDateString() -> String? {
        let currentDateTime = Date()
        return currentDateTime.description
    }
    
    static func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    static func getFirstLastFromEmail(email:String) -> [String] {
    
        var listOfNames = ["", ""]
        
        do {
            
            let textBefore = email.components(separatedBy: "@")
            
            if ( textBefore.count >= 2) {
                let names = textBefore[0].components(separatedBy:".")
                
                if ( names.count >= 2) {
                    listOfNames[0] = names[0]
                    listOfNames[1] = names[1]
                } else if ( names.count == 1 ) {
                    listOfNames[0] = names[0]
                }
            }
            return listOfNames
            
        } catch let _ {
            return listOfNames
        }
       
    }
}
