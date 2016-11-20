//
//  User+CoreDataClass.swift
//  language
//
//  Created by Arif Khan on 11/17/16.
//  Copyright © 2016 Snnab. All rights reserved.
//

import Foundation
import CoreData


public class User: NSManagedObject {

    convenience init(login: String, pass: String, first: String, last: String, display: String, mode: String,  context : NSManagedObjectContext){
        
        // An EntityDescription is an object that has access to all
        // the information you provided in the Entity part of the model
        // you need it to create an instance of this class.
        
        if let ent = NSEntityDescription.entity(forEntityName: "User",
                                                in: context){
            
            
            self.init(entity: ent, insertInto: context)
            self.firstName = first
            self.lastName = last
            self.displayName = display
            self.authenticationMode = mode
            self.loginId = login
            self.password = pass
            self.createDate = NSDate()
        }
        else {
            fatalError("Unable to find Entity User!")
        }
    }
}
