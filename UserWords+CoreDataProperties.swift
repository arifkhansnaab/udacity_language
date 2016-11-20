//
//  UserWords+CoreDataProperties.swift
//  language
//
//  Created by Arif Khan on 11/17/16.
//  Copyright © 2016 Snnab. All rights reserved.
//

import Foundation
import CoreData


extension UserWords {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserWords> {
        return NSFetchRequest<UserWords>(entityName: "UserWords");
    }

    @NSManaged public var lastTouched: NSDate?
    @NSManaged public var learningStatus: String?
    @NSManaged public var loginId: String?
    @NSManaged public var word: String?

}
