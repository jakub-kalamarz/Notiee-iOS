//
//  CoreDataStore.swift
//  Notiee
//
//  Created by Kuba on 22/05/2020.
//  Copyright © 2020 Jakub. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct Store {
    static let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        return context
    }()
    
    static func newNote() -> Note {
        let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context) as! Note
        
        return note
    }
    
    static func fetchNote() -> [Note] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do {
            let result = try context.fetch(request) as! [Note]
            return result
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
    }
}
