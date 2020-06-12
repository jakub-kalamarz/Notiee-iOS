//
//  Note+CoreDataProperties.swift
//  Notiee
//
//  Created by Kuba on 22/05/2020.
//  Copyright © 2020 Jakub. All rights reserved.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }
    @NSManaged public var title: String?
    @NSManaged public var text: String?
    @NSManaged public var category: Category?
    @NSManaged public var color: String?

}
