//
//  CoreDataManager.swift
//  SampleCoreData
//
//  Created by Sidhi Artha on 03/02/18.
//  Copyright © 2018 Sidhi Artha. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject
{
    static var shared = CoreDataManager()
    // MARK: - Core Data stack
    
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "SampleCoreData")
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
        return container
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "SampleCoreData", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.git.JajakPendapat" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let options = [ NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true ]
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SampleCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let error = NSError(domain: "sidhiartha", code: 9999, userInfo: dict)
            
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
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        if #available(iOS 10.0, *) {
            return persistentContainer.viewContext
        } else {
            // Fallback on earlier versions
            let coordinator = self.persistentStoreCoordinator
            var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            managedObjectContext.persistentStoreCoordinator = coordinator
            return managedObjectContext
        }
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Core Data Loading support
    func loadOrCreate(entityName: String, by: Dictionary<String, String>) -> NSManagedObject
    {
        if let object = load(entityName: entityName, by: by) {
            return object
        }
        
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)
        return NSManagedObject(entity: entity!, insertInto: managedObjectContext)
    }
    
    func load(entityName: String, by: Dictionary<String, String>) -> NSManagedObject?
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let andPredicate = dictToPredicate(dict: by)
        fetchRequest.predicate = andPredicate
        
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            if result.count == 0 || !(result[0] is NSManagedObject)
            {
                return nil
            }
            
            return result[0] as? NSManagedObject
        } catch let error as NSError
        {
            print("error on fetch \(error)")
            return nil
        }
    }
    
    func loadAll(entityName: String) -> [NSManagedObject]
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            if result.count == 0 || !(result[0] is NSManagedObject)
            {
                return []
            }
            
            return result as! [NSManagedObject]
        } catch let error as NSError
        {
            print("error on fetch \(error)")
            return []
        }
    }
    
    // MARK: - Core Data Loading support
    func delete(entityName: String, by: Dictionary<String, String>)
    {
        if let object = load(entityName: entityName, by: by)
        {
            managedObjectContext.delete(object)
            saveContext()
        }
    }
    
    private func dictToPredicate(dict: Dictionary<String, String>) -> NSPredicate
    {
        var predicates = [NSPredicate]()
        for (key, value) in dict
        {
            let predicate = NSPredicate(format: "\(key) = '\(value)'")
            predicates.append(predicate)
        }
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
}
