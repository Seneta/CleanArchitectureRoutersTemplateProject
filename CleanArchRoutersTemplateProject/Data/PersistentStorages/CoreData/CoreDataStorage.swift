//
//  CoreDataStorage.swift
//  CleanArchRoutersTemplateProject
//
//  Created by User6 on 12/19/19.
//  Copyright © 2019 User6. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStorage: NSObject {
     lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private func saveContext() {
        context.perform {
        do {
            try self.context.save()
        } catch {
            fatalError("Unresolved error \(error as NSError), \((error as NSError).userInfo)")}
        }
    }
}

extension CoreDataStorage: ItemsCDStorage {

    func getItems(closure: @escaping ([CDItemData]?) -> Void ) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDItemData")
        
        do {
            let items = try context.fetch(fetchRequest) as? [CDItemData]
            closure(items)
        } catch {
            closure(nil)
            print("Unable to fetch managed object")
        }
    }
    
    func createItem() -> CDItemData? {
        let entityDescription = NSEntityDescription.entity(forEntityName: "CDItemData", in: context)!
        let item = CDItemData(entity: entityDescription, insertInto: context)
        return item
    }
    
    func getItem(id: String, closure: @escaping (CDItemData?) -> Void ) {
        let predicate = NSPredicate(format: "id == %@", id)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDItemData")
        fetchRequest.predicate = predicate
        
        do {
            let items = try context.fetch(fetchRequest) as? [CDItemData]
            closure((items ?? []).first)
        } catch {
            print("Unable to fetch managed object")
            closure(nil)
        }
    }

    func saveChanges() {
        saveContext()
    }
}
