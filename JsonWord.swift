//
//  Word.swift
//  language
//
//  Created by Arif Khan on 12/10/16.
//  Copyright © 2016 Snnab. All rights reserved.
//

import Foundation
import CoreData

public class JsonWord  {
    var sourceWord: String? = ""
    var translatedWord: String? = ""
    var language: String? = ""
    var publishedDate: String? = ""
    var publishedBy: String? = ""
    
    init (sourceWord: String, translatedWord: String, language: String, publishedDate: String, publishedBy: String) {
        self.sourceWord = sourceWord
        self.translatedWord = translatedWord
        self.language = language
        self.publishedDate = publishedDate
        self.publishedBy = publishedBy
    }
    
    func getConvertedJson() -> NSMutableDictionary {
        let para:NSMutableDictionary = NSMutableDictionary()
        para.setValue(self.sourceWord, forKey: "sourceWord")
        para.setValue(self.translatedWord, forKey: "translatedWord")
        para.setValue(self.language, forKey: "language")
        para.setValue(self.publishedDate, forKey: "publishedDate")
        para.setValue(self.publishedBy, forKey: "publishedBy")
        return para
    }
}
