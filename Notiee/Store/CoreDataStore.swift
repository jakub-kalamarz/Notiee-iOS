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
    
    // MARK:- Notes methods
    
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
            fatalError("Failed to fetch notes: \(error)")
        }
    }
    
    static func save() -> Void {
        do {
           try context.save()
          } catch {
           print("Failed saving")
        }
    }
    
    static func delete(_ object: NSManagedObject) {
        context.delete(object)
    }
    
    static func deleteAllNotes() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        let batchDelete = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(batchDelete)
        } catch {
            fatalError("Failed to delete notes: \(error)")
        }
    }
    
    static func fetchCategories() -> [Category] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        do {
            let result = try context.fetch(request) as! [Category]
            return result
        } catch {
            fatalError("Failed to fetch categories: \(error)")
        }
    }
    
    static func colors() -> [String] {
        return["#fad390","#f6b93b","#fa983a","#e58e26","#f8c291","#e55039","#eb2f06","#b71540","#6a89cc","#4a69bd","#1e3799","#0c2461","#82ccdd","#60a3bc","#3c6382","#0a3d62","#b8e994","#78e08f","#38ada9","#079992"]
        
    }
    
    static func getRandomColor() -> CGColor {
        let colors = ["#fad390","#f6b93b","#fa983a","#e58e26","#f8c291","#e55039","#eb2f06","#b71540","#6a89cc","#4a69bd","#1e3799","#0c2461","#82ccdd","#60a3bc","#3c6382","#0a3d62","#b8e994","#78e08f","#38ada9","#079992"]
        let selectedColor = colors.randomElement()
        let color = UIColor(hex: selectedColor!)
        let cgColor = color!.cgColor
        return cgColor
    }
    
    static func getRandomStringColor() -> String {
        if let selectedColor = colors().randomElement() {
            return selectedColor
        }
        return "#fad390"
    }
}
