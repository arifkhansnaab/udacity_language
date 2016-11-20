//
//  UserWords+CoreDataClass.swift
//  language
//
//  Created by Arif Khan on 11/17/16.
//  Copyright © 2016 Snnab. All rights reserved.
//

import Foundation
import CoreData


public class UserWords: NSManagedObject {
    convenience init(loginId: String, sourceWord: String, status: String?, context : NSManagedObjectContext){
        
        // An EntityDescription is an object that has access to all
        // the information you provided in the Entity part of the model
        // you need it to create an instance of this class.
        
        if let ent = NSEntityDescription.entity(forEntityName: "UserWords",
                                                in: context){
            
            
            self.init(entity: ent, insertInto: context)
            self.word = sourceWord
            self.loginId = loginId
            self.learningStatus = status
            //self.lastTouched = NSData()
            
            
        }
        else {
            fatalError("Unable to find Entity User!")
        }
    }

}
