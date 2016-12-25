//
//  User+CoreDataProperties.swift
//  language
//
//  Created by Arif Khan on 11/17/16.
//  Copyright © 2016 Snnab. All rights reserved.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User");
    }

    @NSManaged public var authenticationMode: String?
    @NSManaged public var displayName: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var loginId: String?
    @NSManaged public var password: String?
    @NSManaged public var createDate: NSDate?
    @NSManaged public var relationship: NSSet?

}

// MARK: Generated accessors for relationship
extension User {

    @objc(addRelationshipObject:)
    @NSManaged public func addToRelationship(_ value: Word)

    @objc(removeRelationshipObject:)
    @NSManaged public func removeFromRelationship(_ value: Word)

    @objc(addRelationship:)
    @NSManaged public func addToRelationship(_ values: NSSet)

    @objc(removeRelationship:)
    @NSManaged public func removeFromRelationship(_ values: NSSet)

}
