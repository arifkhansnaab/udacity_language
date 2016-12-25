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
}
