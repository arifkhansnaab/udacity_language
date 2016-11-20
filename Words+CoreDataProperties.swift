//
//  Words+CoreDataProperties.swift
//  language
//
//  Created by Arif Khan on 11/17/16.
//  Copyright © 2016 Snnab. All rights reserved.
//

import Foundation
import CoreData


extension Words {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Words> {
        return NSFetchRequest<Words>(entityName: "Word");
    }

    @NSManaged public var convertedLanguageWord: String?
    @NSManaged public var convertedRomanWord: String?
    @NSManaged public var language: String?
    @NSManaged public var sourceWord: String?
    @NSManaged public var createDate: NSDate?

}
