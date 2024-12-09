//
//  UserNote+CoreDataProperties.swift
//  NotesApplication
//
//  Created by Celestial on 02/12/24.
//
//

import Foundation
import CoreData


extension UserNote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserNote> {
        return NSFetchRequest<UserNote>(entityName: "UserNote")
    }

    @NSManaged public var content: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var title: String?

}

extension UserNote : Identifiable {

}
