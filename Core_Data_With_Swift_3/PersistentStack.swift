//
//  PersistentStack.swift
//  PersistentContainerTestNoMO
//
//  Created by Franks, Kent on 4/10/17.
//  Copyright © 2017 Franks, Kent. All rights reserved.
//

import Foundation
import CoreData

class PersistenceStack {
    
    static let sharedStack = PersistenceStack()

    lazy var mainMoc: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    lazy var privateMoc: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "KefTestModel")
        container.loadPersistentStores(completionHandler: { [weak self](storeDescription, error) in
            if let error = error {
                NSLog("CoreData error \(error), \(error._userInfo)")
                self?.errorHandler(error: error)
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.newBackgroundContext()
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        
//        persistentContainer.performBackgroundTask({ (context) in
//            if context.hasChanges {
//                do {
//                    try context.save()
//                } catch {
//                    let nserror = error as NSError
//                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//                }
//            }
//        })

    }
    
    func errorHandler(error: Error) {
        print("CoreData error \(error), \(error._userInfo)")
    }

    
}
