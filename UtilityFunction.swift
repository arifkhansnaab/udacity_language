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
        let val = (knownWords!/tword!)*100
        return Int(round(val)).description
    }
}
