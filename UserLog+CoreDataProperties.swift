//
//  UserLog+CoreDataProperties.swift
//  language
//
//  Created by Arif Khan on 11/17/16.
//  Copyright © 2016 Snnab. All rights reserved.
//

import Foundation
import CoreData


extension UserLog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserLog> {
        return NSFetchRequest<UserLog>(entityName: "UserLog");
    }

    @NSManaged public var loginDate: NSDate?
    @NSManaged public var loginId: String?

}
